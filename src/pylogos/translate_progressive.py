from typing import Any, Dict, Tuple
import re
import copy
from src.pylogos.algorithm.MRP import MRP
from src.utils.rewrite_sentence_gpt import *
from src.sql_generator.sql_gen_utils.utils import load_graphs, load_objs
from src.pylogos.translate import translate
from src.sql_generator.sql_gen_utils.sql_genetion_utils import (
    get_prefix,
    get_tab_name_alias,
    find_existing_rel_node,
    get_col_name_alias,
)
from src.pylogos.query_graph.koutrika_query_graph import (
    Attribute,
    Query_graph,
    Relation,
)
from src.query_tree.query_tree import QueryTree, QueryBlock, BaseTable, get_global_index
import argparse

TEMPLATE = {
    "global_template": {
        "text": "Please write out a single interrogative sentence for {BLOCK_NAME} in detail without any explicit reference to {SUB_BLOCK_NAMES}.",
        "variables": ["{BLOCK_NAME}", "{SUB_BLOCK_NAMES}"],
    },
    "global_template_2": {
        "text": "Please combine {ALL_BLOCK_NAMES} in a single interrogative sentence for {BLOCK_NAME} in detail without any explicit reference to {SUB_BLOCK_NAMES}.",
        "variables": ["{ALL_BLOCK_NAMES}", "{BLOCK_NAME}", "{SUB_BLOCK_NAMES}"],
    },
    "global_template_has_no_child": {
        "text": "Writes out a single interrogative sentence corresponding to {BLOCK_NAME} in detail.",
        "variables": ["{BLOCK_NAME}"],
    },
    "local_template": {
        "text": "{BLOCK_NAME} is to {BLOCK_TEXT}",
        "variables": ["{BLOCK_NAME}", "{BLOCK_TEXT}"],
    },
    "block_prefix": "B",
}


def templatize(template, variables, variable_to_val):
    text = template
    for variable in variables:
        assert variable in variable_to_val.keys()
        value = variable_to_val[variable]
        text = text.replace(variable, value)

    return text


def translate_progressive(
    query_tree: QueryBlock,
    root_block_name: str,
    query_objs: Dict[str, Dict],
    query_graphs: Dict[str, Query_graph],
    use_gpt: bool = True,
) -> Tuple[str, Dict[str, Any]]:
    def update_query_graph(cur_block_name, cur_query_graph, correlation_predicate, cur_query_obj, cur_node):
        rel_name_A = correlation_predicate
        prefix = correlation_predicate[0]
        correlated_col = correlation_predicate[1]
        correlated_tab_name = correlated_col.split(".")[0]
        correlated_col_name = correlated_col.split(".")[1]

        correlated_tab_alias = get_tab_name_alias(correlated_tab_name)

        # rel_nodes
        graph = copy.deepcopy(cur_query_graph)
        rel_nodes = graph.relations

        cur_rel_node = Relation(correlated_tab_name, correlated_tab_alias, is_primary=True)  # Nesting level is always 0
        idx = find_existing_rel_node(rel_nodes, cur_rel_node)
        if idx == -1:
            cur_rel_node_2 = Relation(correlated_tab_name, correlated_tab_alias, is_primary=False)
            idx = find_existing_rel_node(rel_nodes, cur_rel_node_2)

        if idx != -1:
            cur_rel_node = rel_nodes[idx]
            cur_rel_node.is_primary = True
            pushdowned_foreach_block = None
        else:  # HAVING QUERY
            assert len(rel_nodes) == 1 and rel_nodes[0].node_name.startswith(prefix.split("_")[0])
            idx = 0
            cur_rel_node = rel_nodes[0]
            correlated_tab_name = cur_rel_node.node_name
            pushdowned_foreach_block = cur_rel_node.node_name

        assert idx != -1

        grouping_columns = []
        if cur_query_obj["type"]["group"]:
            grouping_columns = cur_query_obj["group"]
            grouping_columns = [col.replace(prefix, "") for col in grouping_columns]

        if correlated_col not in grouping_columns:
            # Add grouping
            g_col_name_graph = "g_" + correlated_col_name
            g_col_name_alias = get_col_name_alias(correlated_tab_name, correlated_col_name, "NONE")
            g_cur_col_node = Attribute(g_col_name_graph, g_col_name_alias)
            graph.connect_grouping(cur_rel_node, g_cur_col_node)

        # Add projection
        s_col_name_graph = "s_" + correlated_col_name
        s_col_name_alias = get_col_name_alias(correlated_tab_name, correlated_col_name, "NONE")
        s_cur_col_node = Attribute(s_col_name_graph, s_col_name_alias)

        graph.connect_membership(cur_rel_node, s_cur_col_node)

        return graph, pushdowned_foreach_block

    def preorder_traverse(parent, cur_node, query_objs, idx, map):
        childs = query_objs[cur_node]["childs"]
        if not childs:
            if parent:
                key = parent + cur_node
            else:
                key = cur_node
            map[key] = idx
            return idx + 1, map

        for child in childs:
            child_name = get_prefix(child[0], child[1])[:-1]
            idx, map = preorder_traverse(cur_node, child_name, query_objs, idx, map)

        if parent:
            key = parent + cur_node
        else:
            key = cur_node
        map[key] = idx
        return idx + 1, map

    texts = []
    mappings = []
    correlation_predicates = {}

    # Build a mapping tree: global key to block id by pre-order traversal
    _, key_to_block_id = preorder_traverse(parent=None, cur_node=root_block_name, query_objs=query_objs, idx=1, map={})

    candidates = [(None, root_block_name, query_tree)]
    pushdowned_foreach_blocks = {}
    while len(candidates) > 0:
        parent_block_name, cur_block_name, cur_node = candidates.pop(0)
        cur_query_graph = query_graphs[cur_block_name]
        cur_query_obj = query_objs[cur_block_name]

        if parent_block_name and cur_block_name in correlation_predicates[parent_block_name].keys():
            cur_query_graph, pushdowned_foreach_block = update_query_graph(
                cur_block_name,
                cur_query_graph,
                correlation_predicates[parent_block_name][cur_block_name],
                cur_query_obj,
                cur_node,
            )
            if pushdowned_foreach_block:
                assert pushdowned_foreach_block not in pushdowned_foreach_blocks.keys()
                pushdowned_foreach_blocks[pushdowned_foreach_block] = correlation_predicates[parent_block_name][
                    cur_block_name
                ]
        elif parent_block_name and cur_block_name in pushdowned_foreach_blocks.keys():
            cur_query_graph, pushdowned_foreach_block = update_query_graph(
                cur_block_name,
                cur_query_graph,
                pushdowned_foreach_blocks[cur_block_name],
                cur_query_obj,
                cur_node,
            )
            assert pushdowned_foreach_block is None
        text, mapping = MRP()(cur_query_graph.query_subjects[0], None, None, cur_query_graph)

        # simplify block name
        for child in cur_query_obj["childs"]:
            child_name = get_prefix(child[0], child[1])[:-1]
            key = cur_block_name + child_name
            simplified_block_name = TEMPLATE["block_prefix"] + str(key_to_block_id[key])
            text = re.sub(child_name + "(?![0-9])", simplified_block_name, text)

        if parent_block_name:
            key = parent_block_name + cur_block_name
        else:
            key = cur_block_name
        cur_idx = key_to_block_id[key] - 1
        if len(texts) <= cur_idx:
            texts.extend([None for _ in range(cur_idx - len(texts) + 1)])
            mappings.extend([None for _ in range(cur_idx - len(mappings) + 1)])
        assert texts[cur_idx] is None
        texts[cur_idx] = text
        mappings[cur_idx] = mapping

        # update correlation_predicates
        correlation_predicates[cur_block_name] = {}
        if cur_query_obj["correlation_predicates_origin"]:
            for predicate in cur_query_obj["correlation_predicates_origin"]:
                inner_prefix = predicate[0]
                inner_block_name = inner_prefix[:-1]
                correlation_predicates[cur_block_name][inner_block_name] = predicate

        # Traverse query_tree's children
        for child in cur_query_obj["childs"]:
            child_name = get_prefix(child[0], child[1])[:-1]
            child_node = cur_node.get_child_table(child_name)
            candidates.append((cur_block_name, child_name, child_node))

    root_block_name = TEMPLATE["block_prefix"] + str(key_to_block_id[root_block_name])
    sub_block_names = []
    whole_text = ""
    for idx, text in enumerate(texts):
        simplified_block_name = TEMPLATE["block_prefix"] + str(idx + 1)
        if simplified_block_name != root_block_name:
            sub_block_names.append(simplified_block_name)

        template = TEMPLATE["local_template"]
        variable_to_val = {"{BLOCK_NAME}": simplified_block_name, "{BLOCK_TEXT}": text}
        block_text = templatize(template["text"], template["variables"], variable_to_val)
        whole_text += block_text + "\n"

    if sub_block_names:
        template = TEMPLATE["global_template"]
        variable_to_val = {"{BLOCK_NAME}": root_block_name, "{SUB_BLOCK_NAMES}": ", ".join(sub_block_names)}
        global_text = templatize(template["text"], template["variables"], variable_to_val)

        # template = TEMPLATE["global_template_2"]
        # variable_to_val = {
        #    "{BLOCK_NAME}": root_block_name,
        #    "{SUB_BLOCK_NAMES}": ", ".join(sub_block_names),
        #    "{ALL_BLOCK_NAMES}": ", ".join(sub_block_names + [root_block_name]),
        # }
        global_text = templatize(template["text"], template["variables"], variable_to_val)

    else:
        template = TEMPLATE["global_template_has_no_child"]
        variable_to_val = {"{BLOCK_NAME}": root_block_name}
        global_text = templatize(template["text"], template["variables"], variable_to_val)

    templatized_text = whole_text + global_text + "\n"
    if use_gpt:
        final_text = rewrite_sentence(templatized_text)  # 비싼 모델은 돈이 듭니다. 참고만 하세요.
    else:
        templatized_text = templatized_text.replace("\n", " ")
        final_text = ""

    return templatized_text, final_text


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--query_paths",
        nargs="+",
        default=[
            "/home/hjkim/PRODA/non-nested/result.out",
            "/home/hjkim/PRODA/non-nested/result2.out",
            "/home/hjkim/PRODA/non-nested/result3.out",
        ],
    )
    parser.add_argument("--output_path", type=str, default="/home/hjkim/PRODA/translation2")
    args = parser.parse_args()

    query_objs = {}
    query_graphs = {}
    query_trees = []
    keys = []
    for query_path in args.query_paths:
        with open(query_path, "r") as fp:
            q_count = len(fp.readlines())
        loaded_objs = load_objs(query_path + ".obj", q_count)
        loaded_graphs = load_graphs(query_path + ".graph", q_count)
        for loaded_obj, loaded_graph in zip(loaded_objs, loaded_graphs):
            block_name = get_prefix(loaded_obj["nesting_level"], loaded_obj["unique_alias"])[:-1]
            query_objs[block_name] = loaded_obj
            query_graphs[block_name] = loaded_graph[1]
            query_trees.append((block_name, loaded_graph[0]))

    set_openai()
    with open(args.output_path, "w") as wf:
        for key, query_tree in query_trees:
            if key.startswith("N3"):
                input_text, gpt_text = translate_progressive(
                    query_tree.root, key, query_objs, query_graphs, use_gpt=False
                )
                wf.write(f"{query_objs[key]['sql']}\t{input_text}\n")
                print("GPT INPUT: {}".format(input_text))
                print("GPT OUTPUT: {}".format(gpt_text))
