import copy
import unittest

# Load template class
from src.template.template import Generic_template, Specific_template, template_selection
# Load template files
from src.template.generic_template import generic_templates
from src.template.specific_template_student import specific_templates

# Input data to test
from tests.test_modified_algorithm.utils import query_graph_for_simple_selection, \
                                query_graph_for_multi_projection, \
                                query_graph_for_multi_projection_and_selection, \
                                query_graph_for_correlation, \
                                query_graph_for_group_by_having, \
                                query_graph_for_order_by_limit, \
                                query_graph_for_multi_predicate_with_or, \
                                query_graph_for_multi_sublink_and_nested_sublink, \
                                query_graph_for_multi_projection_from_different_relations


class Test_template_selection(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_template_selection, self).__init__(*args, **kwargs)
        self._templates = None

    @property
    def templates(self):
        if not self._templates:
            g_templates = []
            s_templates = []
            for g_raw_template in generic_templates:
                g_template = Generic_template(g_raw_template)
                g_templates.append(g_template)

            for s_raw_template in specific_templates:
                s_template = Specific_template(s_raw_template)
                s_templates.append(s_template)

            self._templates = {
                "generic": g_templates, 
                "specific": s_templates
            }
        return self._templates

    def _evaluate_template_set(self, gold_list, pred_list):
        gold_list = copy.deepcopy(gold_list)
        pred_list = copy.deepcopy(pred_list)
        def is_identical_template(t1, t2):
            if len(t1) != len(t2):
                return False
            for i1, i2 in zip(t1, t2):
                try:
                    if i1.name != i2.name:
                        return False
                except:
                    if i1 != i2:
                        return False
            return True
        cnt = 0
        gold_raw_template_paths = [item.raw_template['path'] for item in gold_list]
        pred_raw_template_paths = [item.raw_template['path'] for item in pred_list]
        for pred_item in pred_raw_template_paths:
            for gold_item in gold_raw_template_paths:
                if is_identical_template(pred_item, gold_item):
                    gold_raw_template_paths.remove(gold_item)
                    cnt += 1
                    break
        return cnt / len(gold_list)

    def test_simple_selection(self):
        # prepare data
        query_graph = query_graph_for_simple_selection()
        templates = self.templates
        gold_templates = [
            templates['generic'][0],
            templates['generic'][4],
            templates['specific'][0]
        ]
        # Template Selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

    def test_multi_projection(self):
        # Prepare data
        query_graph = query_graph_for_multi_projection()
        templates = self.templates
        gold_templates = [
            templates['generic'][0],
            templates['generic'][0],
            templates['generic'][4],
            templates['specific'][0]
        ]
        # Template Selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")
    
    def test_multi_projection_and_selection(self):
        # Prepare data
        query_graph = query_graph_for_multi_projection_and_selection()
        templates = self.templates
        gold_templates = [
            templates['generic'][0],
            templates['generic'][0],
            templates['generic'][4],
            templates['generic'][4],
            templates['specific'][0]
        ]
        # Template Selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

    def test_correlation(self):
        # Prepare data
        query_graph = query_graph_for_correlation()
        templates = self.templates
        gold_templates = [
            templates['specific'][0],
            templates['specific'][1],
            templates['generic'][0], # projection
            templates['generic'][0], # projection
            templates['generic'][2], # nesting selection
            templates['generic'][4], # value selection
            templates['generic'][10], # correlation
        ]
        # Template selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

    def test_group_by_having(self):
        # Prepare data
        query_graph = query_graph_for_group_by_having()
        templates = self.templates
        gold_templates = [
                templates['generic'][3],
                templates['generic'][4],
                templates['generic'][6],
                templates['generic'][7],
                templates['specific'][0]
        ]
        # Template selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, f"eval result:{eval_result} ({eval_result*len(gold_templates)}/{len(gold_templates)})")

    def test_order_by_limit(self):
        # Prepare data
        query_graph = query_graph_for_order_by_limit()        
        templates = self.templates
        gold_templates = [
            templates['generic'][0],
            templates['generic'][5],
            templates['generic'][8]
        ]
        # Template selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

    def test_multi_predicate_with_or(self):
        # Prepare data
        query_graph = query_graph_for_multi_predicate_with_or()
        templates = self.templates
        gold_templates = [
            templates['generic'][0],
            templates['generic'][4],
            templates['generic'][4],
            templates['generic'][4],
            templates['generic'][4]
        ]
        # Template selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

    def test_multi_sublink_and_nested_sublink(self):
        # Prepare data
        query_graph = query_graph_for_multi_sublink_and_nested_sublink()
        templates = self.templates
        gold_templates = [
            templates['specific'][0], # Join
            templates['generic'][0], # Projection
            templates['generic'][4], # val selection
            templates['generic'][4], # val selection
            templates['generic'][9], # nesting w/ aggregation
            templates['generic'][2] # nesting w/o aggreagation
        ]
        # Template selection
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

    def test_multiple_projection_from_different_relations(self):
        # Prepare data
        query_graph = query_graph_for_multi_projection_from_different_relations()
        templates = self.templates
        gold_templates = [
            templates['specific'][0], # Join
            templates['generic'][0], # Projection
            templates['generic'][0], # Projection
            templates['generic'][4], # Val selection
            templates['generic'][4] # Val selection
        ]
        # Template selectoin
        selected_templates = template_selection(query_graph, templates)
        # Eval
        eval_result = self._evaluate_template_set(gold_templates, selected_templates)
        self.assertTrue(eval_result == 1, "message")

if __name__ == "__main__":
    unittest.main()
