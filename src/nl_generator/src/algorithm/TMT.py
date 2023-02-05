import numpy as np
import networkx as nx
from src.query_graph.koutrika_query_graph import Query_graph, Node, Value, Selection, Membership, Predicate
from src.template.kourtrika_template import Generic_template
from tests.test_koutrika_et_al_2010.utils import query_graph_to_generic_templates


class TMT():
    def __init__(self):
        pass 

    def _cover_all_edges_with_generic_templates(self, G, template_set):
        generic_templates = query_graph_to_generic_templates(G)

        # Get node pairs that are covered with specific templates
        node_pair_set = list()
        for template in template_set:
            for src, dst in template.graph.edges:
                node_pair_set.append((src, dst))
                node_pair_set.append((dst, src))

        # For each generic template
        uncovered_generic_templates = []
        for generic_template in generic_templates:
            # To use student as the root node in the TST algorithm
            CREATE_SAME_TEMPLATE_SET_WITH_PAPER_FOR_DEBUGGING = True
            if CREATE_SAME_TEMPLATE_SET_WITH_PAPER_FOR_DEBUGGING:
                if generic_template.nl_description in ['comments are given by students']:
                    continue

            # check if every adjacent node pair set is covered with the specific templates
            if not all([(src, dst) in node_pair_set for src, dst in generic_template.graph.edges]):
                for src, dst in generic_template.graph.edges:
                    node_pair_set.append((src, dst))
                    node_pair_set.append((dst, src))
                uncovered_generic_templates.append(generic_template)

        for generic_template in uncovered_generic_templates:
            template_set.add(generic_template)

        return template_set

    def _template_selection(self, G, I, all_templates):
        """
        Input:
            - G: query graph ()
            - I: (inverted index over the template graphs, that is edges to template graphs)
        Output:
            - cg: set (a minimum set of composeable graphs)
        Description:
            - 
        """
        composeable_templates = list()
        candidate_solutions = list()

        # Initialize matrix to 
        M = np.zeros((len(G.edges), len(all_templates)), dtype=bool)
        # edges = [G.edges[src, dst]['data'] for src, dst in G.edges]
        # edge_to_idx = {edges[i]: i for i in range(len(edges))}
        edge_to_idx = {(src.signature, dst.signature): i for i , (src, dst) in enumerate(G.edges)}

        # Mark template graphs with edges of query graph
        for src, dst in G.edges:
            edge_signature = (src.signature, dst.signature)
            # edge = G.edges[src, dst]['data']
            edge_idx = edge_to_idx[edge_signature]
            # Retrieve templates for edge
            if edge_signature in I:
                retrieved_templates = I[edge_signature]
                for tg in retrieved_templates:
                    M[edge_idx][all_templates.index(tg)] = True

        # Mark templates that covers query graph G
        for tg_idx in range(M.shape[1]):
            template = all_templates[tg_idx]
            if sum(M[:, tg_idx]) == len(template.graph.edges):
                composeable_templates.append(template)
                candidate_solutions.append((set([template]), set([(src.signature, dst.signature) for src, dst in template.graph.edges]), set(template.reference_points)))

        # Sort composeable graphs
        composeable_templates = sorted(composeable_templates, key=lambda t: -len(t.graph.edges))

        # Find minimum set of composeable graphs that covers query graph
        best_solution = None
        while candidate_solutions:
            # sort candidate solutions by number of template graphs
            candidate_solutions = sorted(candidate_solutions, key=lambda k: len(k[1]))
            template_set, edge_set, reference_point_set = candidate_solutions.pop(0)
            print(len(candidate_solutions), len(composeable_templates), len(template_set), len(edge_set), len(reference_point_set))

            templates_to_add = filter(lambda t: t not in template_set and reference_point_set.intersection(set(t.reference_points)), composeable_templates)
            for template in templates_to_add:
                new_template_set = set([template]).union(template_set)
                new_edge_set = edge_set.union(set([(src.signature, dst.signature) for src, dst in template.graph.edges]))
                if len(new_edge_set) == len(edge_set):
                    raise RuntimeError("Something is wrong")
                new_reference_point_set = reference_point_set.union(set(template.reference_points))
                if len(new_edge_set) == len(G.edges):
                    return new_template_set
                else:
                    candidate_solutions.append((new_template_set, new_edge_set, new_reference_point_set))

            # if template_set is better than the current best solution, replace it
            if not best_solution:
                best_solution = (template_set, edge_set)
            else:
                best_template_set, best_edge_set = best_solution
                new_solution_covers_more_edge = len(best_edge_set) < len(edge_set)
                new_solution_uses_less_template = (len(best_edge_set) == len(edge_set)) and \
                                                    len(best_template_set) > len(template_set)
                if new_solution_covers_more_edge or new_solution_uses_less_template:
                    best_solution = (template_set, edge_set)

        # Append remaining nodes with the edges of the original query graph...?

        return best_solution[0]
    
    def __call__(self, query_graph, templates) -> str:
        # Function described in the paper
        cStr = self._call(query_graph, templates)
        return f"Find {cStr}."

    def _call(self, G, templates):
        """
        Input:
            - G: query graph()
            - I: (inverted index over the template graphs, that is edges to template graphs)
        Output:
            - cStr: string (translated natural language description of query)
        """
        def get_all_non_membership_edges(template_set):
            edge_set = set()
            for template in template_set:
                for src, dst in template.graph.edges:
                    edge = template.graph.edges[src, dst]['data']
                    if type(edge) != Membership:
                        edge_set.add((src, dst))
            return edge_set

        def biased_topological_sort(root_node, templates):
            """
            Assumption:
                - template graphs are connectable to at least one other template graph
            biased towards:
                1. relation priority to membership edges
                2. selection edges to values
                3. all other cases
            return:
                - topological sorted list of templates
            """
            def add_template_to_list(template, ori_temp_list, sorted_temp_list, seen_nodes):
                sorted_temp_list.append(template)
                ori_temp_list.remove(template)
                seen_nodes.update(template.graph.nodes)

            # Prepare
            ## Create new list object (with identical items)
            templates = [_ for _ in templates]
            # List to return
            sorted_template_list = []
            seen_nodes = set()
            
            # Get graphs that contain root node
            root_node_templates = [t for t in templates if root_node in t.graph.nodes]

            # First append template with given root node as a leaf relation
            for template in root_node_templates:
                if root_node in template.graph.leaf_relations:
                    add_template_to_list(template, templates, sorted_template_list, seen_nodes)

            # Append remaining templates containing root node
            for template in root_node_templates:
                if template not in sorted_template_list:
                    add_template_to_list(template, templates, sorted_template_list, seen_nodes)
                    
            # Add remaining templates
            while templates:
                # if in seen relations, add to sorted list
                flag = False
                for template in templates:
                    if any([n in seen_nodes for n in template.graph.nodes]):
                        flag = True
                        add_template_to_list(template, templates, sorted_template_list, seen_nodes)
                if not flag:
                    raise RuntimeError("Templates not composeable!")
            
            return sorted_template_list
        
        def handle_membership_templates(templates):
            def simplify_nl(template):
                return template.nl_description.split(f"of {template.root_relation.label}")[0]
            
            clause_str = ""
            if len(templates) == 1:
                clause_str = templates[0].nl_description
            elif len(templates) == 2:
                for idx, template in enumerate(templates):
                    clause_str += simplify_nl(template) if idx == 0 else f" and {template.nl_description}"
            else:
                for idx, template in enumerate(templates):
                    nl = template.nl_description
                    simplified_nl = simplify_nl(template)
                    if idx == 0:
                        clause_str += simplified_nl
                    elif idx+1 == len(templates):
                        clause_str += f", and {nl}"
                    else:
                        clause_str += f", {simplified_nl}"
            return f" {clause_str}"

        def handle_selection_templates(templates):
            def simplify_nl(template):
                return template.nl_description.split(f"{template.root_relation.label} ")[1]

            clause_str = ""
            if len(templates) == 1:
                clause_str = templates[0].nl_description
            elif len(templates) == 2:
                for idx, template in enumerate(templates):
                    clause_str += template.nl_description if idx == 0 else f" and {simplify_nl(template)}"
            else:
                for idx, template in enumerate(templates):
                    nl = template.nl_description
                    simplified_nl = simplify_nl(template)
                    if idx == 0:
                        clause_str += simplified_nl
                    elif idx+1 == len(templates):
                        clause_str += f", and {simplified_nl}"
                    else:
                        clause_str += f", {simplified_nl}"
            return clause_str

        def handle_other_templates(templates, remaining_template_groups):
            # Recursively find other category with the reference leaf relation of these relations
            phrase_str_list = []
            for template in templates:
                phrase_str_list += [template.nl_description]
                # Find one composeable template
                selected_template_groups = []
                for template_group in remaining_template_groups:
                    root_relation_to_compare, templates_in_group = template_group
                    if root_relation_to_compare in template.graph.relations:
                        selected_template_groups.append(template_group)

                # Remove from list
                for selected_template_group in selected_template_groups:
                    remaining_template_groups.remove(selected_template_group)

                # Perform recursive call
                for selected_template_group in selected_template_groups:
                    clause_str = compose_templates(selected_template_group, remaining_template_groups)
                    phrase_str_list += [clause_str]
            return " and  ".join(phrase_str_list)

        def categorize_templates_by_edges(templates):
            membership_templates = []
            selection_templates = []
            remaining_templates = []
            for template in templates:
                edges = [template.graph.edges[src, dst]['data'] for src, dst in template.graph.all_edges_of(template.root_relation)]
                if any([isinstance(edge, Membership) for edge in edges]):
                    membership_templates.append(template)
                elif any([isinstance(edge, Selection) for edge in edges]):
                    selection_templates.append(template)
                else:
                    remaining_templates.append(template)
            return membership_templates, selection_templates, remaining_templates

        def compose_templates(cur_template_group, group_of_templates):
            phrase_str = ""
            group_subject_relation, templates_in_group = cur_template_group

            # Further categorize templates by edge types
            membership_templates, selection_templates, remaining_templates = categorize_templates_by_edges(templates_in_group)
            projection_clause_str = handle_membership_templates(membership_templates)
            selection_clause_str = handle_selection_templates(selection_templates)
            other_clause_str = handle_other_templates(remaining_templates, group_of_templates)
            phrase_str = compose_clauses(group_subject_relation.label, projection_clause_str, selection_clause_str, other_clause_str)
            return phrase_str

        def compose_clauses(subject_relation_text, p_clause, s_clause, o_clause):
            phrase_str = ""
            if p_clause:
                phrase_str = f"find {p_clause}"
            if p_clause and s_clause:
                phrase_str += s_clause.replace(f"{subject_relation_text} ", " ")
            if o_clause:
                if phrase_str:
                    phrase_str += " and "
                phrase_str += o_clause
            return phrase_str

        # Natural language description to return
        cStr = ""
        template_groups = []

        # Template Selection
        composeable_template = self.template_selection(G, templates)
        
        # Find starting root (i.e. relation w/o any incoming edges, excluding membership edges)
        root_relations = list()
        all_non_membership_edges = get_all_non_membership_edges(composeable_template)
        all_nodes_with_incoming_edges = set([dst for src, dst in all_non_membership_edges])
        for node in filter(lambda r: r not in all_nodes_with_incoming_edges, G.relations):
            root_relations.append(node)

        while root_relations:
            root = root_relations.pop(0)
            selected_templates = list()
            leaves = set([root])

            # biased topological order
            sorted_composeable_template = biased_topological_sort(root, list(composeable_template))

            # Get templates to compose (order sensitive)
            for selected_template in filter(lambda t: any(r in leaves for r in t.graph.relations), sorted_composeable_template):
                # Save templates to translate
                selected_templates.append(selected_template)
                # Append new possible leaves (i.e. reference points)
                leaves = leaves.union(set(selected_template.graph.nodes))

            # Group by root relation
            while selected_templates:
                selected_template = selected_templates.pop(0)
                root_relation = selected_template.root_relation
                is_first_time_seeing_root_relation = True
                for grouping_relation, template_list in template_groups:
                    if root_relation == grouping_relation:
                        template_list.append(selected_template)
                        is_first_time_seeing_root_relation = False
                        break
                if is_first_time_seeing_root_relation:
                    template_groups.append((root_relation, [selected_template]))

            # Translate template graph into NL clause
            cur_template_group = template_groups.pop(0)
            cStr += compose_templates(cur_template_group, template_groups)
        return cStr

    def template_selection(self, G, templates):
        def _create_inverted_index(templates):
            inv_idx = {}
            for template_graph in templates:
                for src, dst in template_graph.graph.edges:
                    edge_signature = (src.signature, dst.signature)
                    if edge_signature not in inv_idx:
                        inv_idx[edge_signature] = [template_graph]
                    else:
                        inv_idx[edge_signature] += [template_graph]
            return inv_idx

        # create inverted index
        inverted_index = _create_inverted_index(templates)
        
        # Function described in the paper
        template_set = self._template_selection(G, inverted_index, templates)
        
        # Add generic templates to cover all edges of the query graph
        template_set = self._cover_all_edges_with_generic_templates(G, template_set)
        
        return template_set
