import copy
import inspect
import networkx as nx

from abc import *
from functools import reduce
from query_graph import Node, Edge, Operation, Ordering, Relation, Attribute, Function, Value
from query_graph import Projection, Selection, Join, Grouping, Having, Limit
from query_graph import Aggregation, OperatorType, Query_graph
# from SQL2Text.query_graph.queryGraph import Node, Edge, Operation, Ordering, Relation, Attribute, Function, Value
# from SQL2Text.query_graph.queryGraph import Projection, Selection, Join, Grouping, Having, Limit
# from SQL2Text.query_graph.queryGraph import Aggregation, OperatorType, Query_graph

def flatten(list_of_list):
    return [element for list in list_of_list for element in list]


class Template:
    def __init__(self, raw_generic_templates, raw_specific_templates):
        self.raw_generic_templates = raw_generic_templates
        self.raw_specific_templates = raw_specific_templates
        self.generic_templates = [Generic_template(raw_generic_template) for raw_generic_template in raw_generic_templates]
        self.specific_templates = [Specific_template(raw_specific_template) for raw_specific_template in raw_specific_templates]


class Template_instance(metaclass=ABCMeta):
    def __init__(self, raw_template=None):
        self._label = ""
        self.raw_template = raw_template
        self.query_graph_path = None
        self.tp_to_qgp_idx_mapping = {}

    def __len__(self):
        return len(self.query_graph_path)

    def __str__(self):
        return self.nl

    @staticmethod
    def add_edge_to_query_graph_path(template, query_graph):
        template.query_graph_path = [(src, dst, query_graph.edges[src, dst]['data']) for src, dst in template.query_graph_path]
        return template

    @property
    def nl_for_grouping(self):
        def is_number(string_to_examine):
            try:
                int(string_to_examine)
                return True
            except:
                return False
        def is_label(string_to_examine):
            return string_to_examine.startswith("l(") and string_to_examine.endswith(")")
        def parse_label(string_to_examine):
            label_str = string_to_examine[2:-1]
            number_start_idx = [idx for idx, c in enumerate(label_str) if is_number(c)][0]
            return label_str[:number_start_idx], int(label_str[number_start_idx:])
        def label_to_template_path_idx(label_str, label_idx):
            if label_str == 'R':
                label = Relation
            elif label_str == 'A':
                label = Attribute
            elif label_str == 'F':
                label = Function
            elif label_str == 'V':
                label = Value
            elif label_str == 'Op':
                label = Operation
            elif label_str == 'Ord':
                label = Ordering
            else:
                raise RuntimeError(f"Label {label_str} Not considered..")

            # Match label from template_path
            match_cnt = 0
            matched_idx = -1
            for template_path_idx, path_item in enumerate(self.template_path):
                if (inspect.isclass(path_item) and label == path_item) or type(path_item) == label:
                    # Match
                    match_cnt += 1
                    if match_cnt == label_idx:
                        matched_idx = template_path_idx
                        break
            assert matched_idx != -1, f"Error on finding label index: {label_str}, {label_idx}"
            return matched_idx

        words = []
        for item in self.raw_template["nl"]:
            if is_label(item):
                tp_idx = label_to_template_path_idx(*parse_label(item))
                qgp_idx, qgp_sub_idx = self.tp_to_qgp_idx_mapping[tp_idx]
                # Heruistic
                name = self.query_graph_path[qgp_idx][qgp_sub_idx].name
                name = name if type(name) == str else str(name)
                if name.endswith(".*"):
                    word = "grouped item"
                    if words[-1] == "'s":
                        words = words[:1]
                    else:
                        words = words[:-1]
                else:
                    word = self.query_graph_path[qgp_idx][qgp_sub_idx].nl
                words.append(word)
            else:
                assert type(item) == str, "Error on creating NL from template"
                words.append(item)
        return " ".join(words)


    @property
    def nl(self):
        def is_number(string_to_examine):
            try:
                int(string_to_examine)
                return True
            except:
                return False
        def is_label(string_to_examine):
            return string_to_examine.startswith("l(") and string_to_examine.endswith(")")
        def parse_label(string_to_examine):
            label_str = string_to_examine[2:-1]
            number_start_idx = [idx for idx, c in enumerate(label_str) if is_number(c)][0]
            return label_str[:number_start_idx], int(label_str[number_start_idx:])
        def label_to_template_path_idx(label_str, label_idx):
            if label_str == 'R':
                label = Relation
            elif label_str == 'A':
                label = Attribute
            elif label_str == 'F':
                label = Function
            elif label_str == 'V':
                label = Value
            elif label_str == 'Op':
                label = Operation
            elif label_str == 'Ord':
                label = Ordering
            else:
                raise RuntimeError(f"Label {label_str} Not considered..")

            # Match label from template_path
            match_cnt = 0
            matched_idx = -1
            for template_path_idx, path_item in enumerate(self.template_path):
                if (inspect.isclass(path_item) and label == path_item) or type(path_item) == label:
                    # Match
                    match_cnt += 1
                    if match_cnt == label_idx:
                        matched_idx = template_path_idx
                        break
            assert matched_idx != -1, f"Error on finding label index: {label_str}, {label_idx}"
            return matched_idx

        words = []
        for item in self.raw_template["nl"]:
            if is_label(item):
                tp_idx = label_to_template_path_idx(*parse_label(item))
                qgp_idx, qgp_sub_idx = self.tp_to_qgp_idx_mapping[tp_idx]
                words.append(self.query_graph_path[qgp_idx][qgp_sub_idx].nl)
            else:
                assert type(item) == str, "Error on creating NL from template"
                words.append(item)
        return " ".join(words)

    @property
    def template_path(self):
        return self.raw_template["path"]

    @property
    def label(self):
        if self._label:
            assert self.query_graph_path, "Please set query graph first!"
            # Convert template path to query graph path
            qg_idx = 0
            matched_query_graph_elements = []
            for item in self.template_path:
                result_idx = self._find_matching_idx_in_query_graph_path(item, self.query_graph_path, qg_idx)
                qg_idx += result_idx + 1
                matched_query_graph_elements.append(self.query_graph_path[result_idx])
            
            # Replace label with one from query graph
            words = [self._parse_label(ele) for ele in self._label]
            return " ".join(words)
        return ""

    @property
    def last_node_of_query_graph_path(self):
        assert self.query_graph_path, "Error. Need to set query graph path first"
        return self.query_graph_path[-1][1]

    @property
    def operation_idx(self):
        return self.query_graph_path[0][-1].operation_idx

    def _parse_label(self, l):
        def is_integer(num):
            try:
                int(num)
                return True
            except:
                return False

        if l.startswith("l(") and l.endswith(")"):
            num_start_idx = [i for i in range(len(l)) if is_integer(l[i])]
            element_type = l[2:num_start_idx]
            element_of_type_idx = l[num_start_idx:-1]
            list_of_selected_type = [ele for ele in self.query_graph_path if type(ele).__name__ == element_type]
            return list_of_selected_type[element_of_type_idx].name
        else:
            return l

    def _find_matching_idx_in_query_graph_path(self, template_path_item, query_graph_path, star_idx=0):
    # TODO: Need to fix this method
        for idx in range(star_idx, len(query_graph_path)):
            target = query_graph_path[idx]
            is_matched = inspect.isclass(target, template_path_item) if inspect.isclass(template_path_item) else target.name == template_path_item.name
            if is_matched:
                break
        # Change to -1 if nothing is matched
        idx = -1 if len(query_graph_path) == idx else idx
        return idx

    def add_schema_template(self, schema_template):
        for path in self.query_graph_path:
            for item in path:
                if issubclass(type(item), Node):
                    item.set_schema_template(schema_template)

    def create_template_to_query_graph_idx_mapping(self):
        def is_equivalent(tp_item, qgp_item):
            return issubclass(type(qgp_item), tp_item) if inspect.isclass(tp_item) else qgp_item.name == tp_item.name
        def move_tp_idx(tp_idx):
            tp_idx += 1
            while tp_idx < len(self.template_path) and not inspect.isclass(self.template_path[tp_idx]) and self.template_path[tp_idx].name == '*':
                tp_idx += 1
            return tp_idx

        tp_idx = 0
        qgp_idx = 0
        while qgp_idx < len(self.query_graph_path):
            # Match first
            if is_equivalent(self.template_path[tp_idx], self.query_graph_path[qgp_idx][0]):
                self.tp_to_qgp_idx_mapping[tp_idx] = (qgp_idx, 0)
                tp_idx = move_tp_idx(tp_idx)
            # Match third
            if is_equivalent(self.template_path[tp_idx], self.query_graph_path[qgp_idx][2]):
                self.tp_to_qgp_idx_mapping[tp_idx] = (qgp_idx, 2)
                tp_idx = move_tp_idx(tp_idx)
            # Match second
            if is_equivalent(self.template_path[tp_idx], self.query_graph_path[qgp_idx][1]):
                self.tp_to_qgp_idx_mapping[tp_idx] = (qgp_idx, 1)
                tp_idx = move_tp_idx(tp_idx)
            # Next state
            qgp_idx += 1
        assert tp_idx == len(self.template_path), f"{tp_idx} vs {len(self.template_path)}"

    def is_matching(self, query_graph_path):
        # Given a path, check if list of node types matches defined template
        qg_idx = 0
        for template_path_item in self.template_path:
            qg_idx = self._find_matching_idx_in_query_graph_path(template_path_item, query_graph_path, qg_idx)
            if qg_idx == -1:
                return False
            qg_idx += 1
        return True

    def set_query_graph_path(self, query_graph_path):
        self.query_graph_path = query_graph_path

    def do_starts_with_edge_type(self, edge_to_compare):
        assert len(self.query_graph_path[0]) == 3, "Error on checking the starting edge: Need to call add_edge_to_query_graph_path first!"
        return type(self.query_graph_path[0][2]) == edge_to_compare

    def do_starts_with_node(self, node_to_compare):
        return self.query_graph_path[0][0] == node_to_compare


class Generic_template(Template_instance):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)


class Specific_template(Template_instance):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)


def get_isomorphic_subgraph_paths(graph, target_sub_graph, node_matcher, edge_matcher):
    digraph_matcher = nx.algorithms.isomorphism.vf2userfunc.DiGraphMatcher(graph, target_sub_graph, node_match=node_matcher, edge_match=edge_matcher)
    subgraph_paths = []
    if digraph_matcher.subgraph_is_isomorphic():
        for subgraph in [_ for _ in digraph_matcher.subgraph_isomorphisms_iter()]: # Not sure if it is each subgraphs or each paths
            subgraph_path = []
            matched_nodes = [_ for _ in subgraph]
            for idx in range(len(matched_nodes)-1):
                src = matched_nodes[idx]
                dst = matched_nodes[idx+1]
                paths = [tmp for tmp in nx.all_simple_edge_paths(graph, src, dst)]
                subgraph_path += paths[0]
            subgraph_paths.append(subgraph_path)
    return subgraph_paths


def is_connectable(template1, template2):
    return Node.is_equivalent(template1[0], template2[0]) or \
        Node.is_equivalent(template1[-1], template2[0]) or \
            Node.is_equivalent(template2[-1], template1[0])


def get_matched_specific_templates(query_graph, template):
    def find_dst_node_for_src_node(graph, src_node, similar_dst):
        possible_dst_nodes = graph.get_all_similar_nodes(similar_dst)
        for dst in possible_dst_nodes:
            if nx.has_path(graph, src_node, dst):
                return dst
        return None

    template_path = template.template_path

    path_log = []
    for idx in range(0, len(template_path)-2, 2):
        src, edge, dst = template_path[idx:idx+3]
        src_node = path_log[-1][-1] if path_log else None
        dst_node = None
        if edge.name == '*':
            if path_log:
                # Given src, find dst
                dst_node = find_dst_node_for_src_node(query_graph, src_node, dst)
            else:
                # Find src and dst
                for possible_src_node in query_graph.get_all_similar_nodes(src):
                    dst_node = find_dst_node_for_src_node(query_graph, possible_src_node, dst)
                    if dst_node: 
                        src_node = possible_src_node
                        break
            # Early stop
            if not dst_node:
                path_log = []
                break
            # Find path
            paths = [_ for _ in nx.all_simple_edge_paths(query_graph, src_node, dst_node)]
            if not paths:
                # Path not found. Early stop
                path_log = []
                break
            path_log += paths[0]
        else:
            # Find matching subgraph
            graph_to_compare = Query_graph()
            graph_to_compare.add_node(src, data=src)
            graph_to_compare.add_node(dst, data=dst)
            graph_to_compare.add_edge(src, dst, data=edge)

            # Get all subgraph matched
            node_matcher = lambda n1,n2: Node.is_similar(n1['data'], n2['data'])
            edge_matcher = lambda e1,e2: Edge.is_similar(e1['data'], e2['data'])

            paths = get_isomorphic_subgraph_paths(query_graph, graph_to_compare, node_matcher, edge_matcher)

            # Filter by previous src and dst
            filtered_paths = list(filter(lambda k: k[0][0] == src_node or not src_node, paths))
            if not filtered_paths:
                # Path not found. Early stop
                path_log = []
                break
            path_log += filtered_paths[0]

    template.set_query_graph_path(path_log)
    return bool(path_log)

def get_matched_generic_templates(query_graph, template):
    def create_dummy_edge_instance(edge_object, src_node, dst_node):
        return edge_object(OperatorType.Equal, src_node, dst_node)  if edge_object == Operation else edge_object(src_node, dst_node)

    template_path = template.template_path
    # Create a graph to compare
    graph_to_compare = Query_graph()
    last_node_instance = None
    for idx in range(0, len(template_path)-2, 2):
        src = template_path[idx]
        edge = template_path[idx+1]
        dst = template_path[idx+2]
        assert issubclass(src, Node) and issubclass(dst, Node) and issubclass(edge, Edge), "Error when constructing graph from generic template"
        src_instance = last_node_instance if last_node_instance else src('') # Load last node instance
        dst_instance = dst(0)
        edge_instance = create_dummy_edge_instance(edge, src_instance, dst_instance)
        graph_to_compare.add_node(src_instance, data=src_instance)
        graph_to_compare.add_node(dst_instance, data=dst_instance)
        graph_to_compare.add_edge(src_instance, dst_instance, data=edge_instance)
        # Save last node instance
        last_node_instance = dst_instance

    # subgraph matchers
    node_matcher = lambda n1,n2: issubclass(type(n1['data']), type(n2['data']))
    edge_matcher = lambda e1,e2: issubclass(type(e1['data']), type(e2['data']))
    # def node_matcher(n1, n2):
    #     print(n1, n2, issubclass(type(n1['data']), type(n2['data'])))
    #     return issubclass(type(n1['data']), type(n2['data']))

    # Main logic
    digraph_matcher = nx.algorithms.isomorphism.vf2userfunc.DiGraphMatcher(query_graph, graph_to_compare, node_match=node_matcher, edge_match=edge_matcher)
    matched_templates = []
    if digraph_matcher.subgraph_is_isomorphic():
        # For each matched subgraph
        for matched_subgraph in digraph_matcher.subgraph_isomorphisms_iter():
            # Create template and set query graph path
            matched_template = copy.deepcopy(template)
            nodes_in_subgraph = [_ for _ in matched_subgraph]
            # Find query graph path
            query_graph_path = []
            for idx in range(len(nodes_in_subgraph)-1):
                src = nodes_in_subgraph[idx]
                dst = nodes_in_subgraph[idx+1]
                possible_paths = [tmp for tmp in nx.all_simple_edge_paths(query_graph, src, dst)]
                query_graph_path += possible_paths[0]
            matched_template.set_query_graph_path(query_graph_path)
            matched_templates.append(matched_template)
    return matched_templates


def to_orig_graph(new_query_graph_path):
    return [(src.ori, dst.ori) for src, dst in new_query_graph_path]


def is_connectable(selected_templates, testing_template):
    def get_src_of_path(path):
        return path[0][0]
    def get_dst_of_path(path):
        return path[-1][-1]
    if not selected_templates: return True
    for selected_template in selected_templates:
        selected_query_graph_path = selected_template.query_graph_path
        if Node.is_equivalent(get_src_of_path(selected_query_graph_path), get_dst_of_path(testing_template))or \
             Node.is_equivalent(get_src_of_path(testing_template), get_dst_of_path(selected_query_graph_path)) or \
               Node.is_equivalent(get_src_of_path(selected_query_graph_path), get_src_of_path(testing_template)):
                 return True
    return False


def remove_path_from_query_graph(query_graph, path):
    # Remove edges along the path
    for src, dst in path:
        query_graph.remove_edge(src, dst)
        # Remove bidirectional connection
        if query_graph.has_edge(dst, src):
            query_graph.remove_edge(dst, src)
    # Remove any nodes without edges
    nodes_to_remove = []
    for node in query_graph.nodes:
        if(len(query_graph.in_edges(node))+len(query_graph.out_edges(node)) == 0):
            nodes_to_remove.append(node)
    for node in nodes_to_remove:        
        query_graph.remove_node(node)
    return None

def duplicate_query_graph(ori_query_graph):
    new_query_graph = copy.deepcopy(ori_query_graph)
    # create mapping to original graph
    for ori_node, new_node in zip(ori_query_graph.nodes, new_query_graph.nodes):
        new_node.ori = ori_node
    for ori_edge, new_edge in zip(ori_query_graph.edges, new_query_graph.edges):
        new_query_graph.edges[new_edge]['data'].ori = ori_query_graph.edges[ori_edge]['data']
    return new_query_graph

def template_selection(ori_query_graph, ori_templates):
    query_graph = duplicate_query_graph(ori_query_graph)
    selected_templates = []

    while len(query_graph):
        templates = copy.deepcopy(ori_templates)
        # For specific templates
        # Filter templates condition 1: that covers graph
        specific_templates_filtered = list(filter(lambda k: get_matched_specific_templates(query_graph, k), templates['specific']))
        # Filter templates condition 2: one repeated node from collected templates
        specific_template_filtered = list(filter(lambda k: is_connectable(selected_templates, k.query_graph_path), specific_templates_filtered))
        # Sort by coverage score
        specific_template_filtered = sorted(specific_template_filtered, key=lambda k: -len(k))

        # Select top specific template
        if specific_template_filtered:
            selected_template = specific_template_filtered[0]
        else:
            # For general templates
            # Filter templates condition 1: that covers graph
            generic_templates_filtered = flatten(map(lambda k: get_matched_generic_templates(query_graph, k), templates['generic']))
            # Filter templates condition 2: one repeated node from collected templates
            generic_template_filtered = list(filter(lambda k: is_connectable(selected_templates, k.query_graph_path), generic_templates_filtered))
            # Sort by coverage score
            generic_template_filtered = sorted(generic_template_filtered, key=lambda k: -len(k))
            # Select top general template
            assert len(generic_template_filtered), "General template selection: Something is wrong"
            selected_template = generic_template_filtered[0]

        # Change selected_template's query_graph_path to nodes of the original graph
        copied_query_graph_path = selected_template.query_graph_path
        selected_template.set_query_graph_path(to_orig_graph(selected_template.query_graph_path))

        # Append
        selected_templates.append(selected_template)

        # Remove nodes and edges of selected path
        remove_path_from_query_graph(query_graph, copied_query_graph_path)
    return selected_templates


def create_template_dic(root, remaining_templates):
    """
    Note: Recursion in template dic should be done regarding the nesting level
    args: 
        all_templates: everytime a template is selected, it's removed from this list
        root: current root relation to categorize templates by
    return:
        TemplateDic: {
            "projection": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ],
            "selection": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ],
            "ordering": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ],
            "grouping": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ],
            "having": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ],
            "limit": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ],
            "join": [
                {
                    "template": Template,
                    "nested": TemplateDic
                },
                ...
            ]
        }
    """
    def combine_template_dic(td1, td2):
        # Combine list for each key
        return  {key: td1.get(key, []) + td2.get(key, []) for key in set([k for k in td1.keys()] + [k for k in td2.keys()])}

    def is_template_ends_with_relation_other_than_root(template, root):
        dst_node = template.last_node_of_query_graph_path
        return type(dst_node) == Relation and dst_node != root

    def templates_for_given_root_and_edge_type(templates, root, edge_type):
        """ has side effect: remove selected elements from the original list """
        selected_templates = list(filter(lambda t: t.do_starts_with_node(root) and t.do_starts_with_edge_type(edge_type), templates))
        # Remove templates
        [templates.remove(t) for t in selected_templates]
        # Return
        return selected_templates

    def recursively_create_template_dic(target_key, target_node_type):
        # 
        template_dic = {target_key: []}
        # Get all related templates
        target_templates = templates_for_given_root_and_edge_type(remaining_templates, root, target_node_type)
        # Create template dics recursively 
        for target_template in target_templates:
            if is_template_ends_with_relation_other_than_root(target_template, root):
                new_root = target_template.last_node_of_query_graph_path
                conncted_template_dic = create_template_dic(new_root, remaining_templates)
                if root.nesting_level == new_root.nesting_level:
                    # Create connected template dic and append with the existing one (they have same nested level)
                    template_dic[target_key].append({"template": target_template, "nested": {}})
                    template_dic = combine_template_dic(template_dic, conncted_template_dic)
                else:
                    # Create a nested template dic and add to the nested item
                    template_dic[target_key].append({"template": target_template, "nested": conncted_template_dic})
            else:
                template_dic[target_key].append({"template": target_template, "nested": {}})
        return template_dic

    def for_projection():
        return {
            "projection": [{"template": t, "nested": {}}for t in templates_for_given_root_and_edge_type(remaining_templates, root, Projection)]
        }

    def for_ordering():
        return {
            "ordering": [{"template": t, "nested": {}}for t in templates_for_given_root_and_edge_type(remaining_templates, root, Ordering)]
        }

    def for_grouping():
        return {
            "grouping": [{"template": t, "nested": {}}for t in templates_for_given_root_and_edge_type(remaining_templates, root, Grouping)]
        }

    def for_limit():
        return {
            "limit": [{"template": t, "nested": {}}for t in templates_for_given_root_and_edge_type(remaining_templates, root, Limit)]
        }

    def for_selection():
        return recursively_create_template_dic("selection", Selection)

    def for_having():
        return recursively_create_template_dic("having", Having)

    def for_join():
        return recursively_create_template_dic("join", Join)

    # Create 
    tmp = reduce(combine_template_dic, [for_projection(), for_selection(), 
                                            for_ordering(), for_grouping(), 
                                            for_having(), for_limit(), for_join()]) \
                                                if remaining_templates else {}
    return tmp

def template_dic_to_nl(template_dic, is_recursive_call=False):
    def concat_phrases(p1, p2):
        return f"{p1} {p2}".strip()
    def captialize(nl):
        return nl[0].upper() + nl[1:] if nl else nl
    # Create complete sentence
    limit_phrase = ""
    projection_phrase = ""
    group_by_phrase = ""
    having_phrase = ""
    selection_phrase = ""
    join_phrase = ""
    ordering_phrase = ""
    if template_dic["join"]:
        if template_dic["selection"]:
            join_phrase = " and ".join([str(t["template"]) for t in template_dic["join"]])

    if template_dic["grouping"]:
        group_by_phrase = concat_phrases("for each", " and ".join([str(t["template"]) for t in template_dic['grouping']]))
        if template_dic["having"]:
            having_phrase = concat_phrases("having", " and ".join([t["template"].nl_for_grouping for t in template_dic['having']]))
    if template_dic["limit"]:
        limit_phrase = " and ".join([str(t["template"]) for t in template_dic["limit"]])
    if template_dic["projection"]:
        # TODO: Add logic to make things more concise
        # Group by relations
        projection_dic = {}
        for item in template_dic["projection"]:
            starting_relation = item["template"].query_graph_path[0][0]
            if starting_relation in projection_dic:
                projection_dic[starting_relation] += [item]
            else:
                projection_dic[starting_relation] = [item]
        
        sub_phrases = []
        for starting_relation, item_list in projection_dic.items():
            tmp = []
            for idx, item in enumerate(item_list):
                sub_phrase = item["template"].nl_for_grouping if template_dic["grouping"] else str(item["template"])
                if " of " in sub_phrase and idx != len(item_list) -1:
                    sub_phrase_without_relation = sub_phrase[:sub_phrase.index(" of ")]
                    tmp.append(sub_phrase_without_relation)
                else:
                    tmp.append(sub_phrase)
            sub_phrases.append(" and ".join(tmp))
        projection_phrase = " and ".join(sub_phrases)

        # projection_phrase = " and ".join([t["template"].nl_for_grouping if template_dic["grouping"] else str(t["template"]) for t in template_dic['projection']])
    if template_dic["selection"]:
        # Group templates by operation idxj
        templates_for_clauses = {}
        for item in template_dic['selection']:
            template = item["template"]
            if template.operation_idx not in templates_for_clauses.keys():
                templates_for_clauses[template.operation_idx] = [item]
            else:
                templates_for_clauses[template.operation_idx] += [item]

        # For each clause, create phrase and combine with coordinating conjunction (i.e. and)
        nl_clauses = []
        for operation_idx, item_dics in templates_for_clauses.items():
            # Create phrase for clause using or
            sub_clauses = []
            for item_dic in item_dics:
                template, nested_template_dic = item_dic['template'], item_dic['nested']
                assert template, "Bad assumption when creating nl for selection"
                sub_clause = str(template)
                if nested_template_dic:
                    sub_clause += f" {template_dic_to_nl(nested_template_dic, is_recursive_call=True)}"
                sub_clauses.append(sub_clause)
            nl_clauses.append(" or ".join(sub_clauses))
        selection_phrase = concat_phrases("for", " and ".join(nl_clauses))

    if template_dic["ordering"]:
        ordering_phrase = concat_phrases("order by", " and ".join([str(t["template"]) for t in template_dic["ordering"]]))

    # Compose
    nl_sentence = ""
    if group_by_phrase:
        nl_sentence = group_by_phrase
        if having_phrase:
            nl_sentence = concat_phrases(nl_sentence, having_phrase)
        nl_sentence += ","
    if projection_phrase:
        if limit_phrase:
            projection_phrase = concat_phrases(limit_phrase, projection_phrase)
        if not is_recursive_call:
            projection_phrase = concat_phrases("show", projection_phrase)
        nl_sentence = concat_phrases(nl_sentence, projection_phrase)
    if selection_phrase:
        nl_sentence = concat_phrases(nl_sentence, selection_phrase)
    if ordering_phrase:
        nl_sentence = concat_phrases(nl_sentence, ordering_phrase)

    # Captialize
    if not is_recursive_call and nl_sentence:
        nl_sentence = captialize(nl_sentence)

    # Modify
    nl_sentence = nl_sentence.replace(" 's", "'s").replace("is is", "is")
    return nl_sentence


def template_composition(all_templates, root, is_recursive_call=False):
    # Create template dic that categorizes given templates
    template_dic = create_template_dic(root, all_templates)

    # Templates to phrases
    return template_dic_to_nl(template_dic)

if __name__ == "__main__":
    from SQL2Text.template.generic_template import generic_templates
    from SQL2Text.template.specific_template_student import specific_templates

    g_templates = []
    s_templates = []
    for g_raw_template in generic_templates:
        g_template = Generic_template(g_raw_template)
        g_templates.append(g_template)

    for s_raw_template in specific_templates:
        s_template = Specific_template(s_raw_template)
        s_templates.append(s_template)
