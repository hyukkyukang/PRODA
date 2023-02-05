import unittest

# Load template class
from src.template.template import Template_instance, Generic_template, Specific_template, template_selection, template_composition
# Load template files
from src.template.generic_template import generic_templates
from src.template.specific_template_student import specific_templates
from src.template.schema_templates.schema_template_student import schema_template

# Input data to test
from tests.test_modified_algorithm.utils import query_graph_for_simple_selection, \
                                query_graph_for_multi_projection, \
                                query_graph_for_multi_projection_and_selection, \
                                query_graph_for_correlation, \
                                query_graph_for_group_by_having, \
                                query_graph_for_order_by_limit, \
                                query_graph_for_multi_predicate_with_or, \
                                query_graph_for_multi_sublink_and_nested_sublink, \
                                query_graph_for_multi_projection_from_different_relations \


class Test_template_composition(unittest.TestCase):
    def __init__(self, *args, **kwargs):
        super(Test_template_composition, self).__init__(*args, **kwargs)
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

    def error_message_for_comparison(self, gold, pred):
        return f"\nGOLD:{gold}\nPRED:{pred}"

    def test_simple_selection(self):
        # Prepare data
        query_graph = query_graph_for_simple_selection()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show id of student who has pets for pets whose age is less than 10"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        #Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_multi_projection(self):
        # Prepare data
        query_graph = query_graph_for_multi_projection()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show first name of student and last name of student who has pets for pets whose age is less than 10"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        #Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_multi_projection_and_selection(self):
        # Prepare data
        query_graph = query_graph_for_multi_projection_and_selection()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show last name of student and first name of student for student whose major is equal to computer science and who has pets for pets whose age is less than 10"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        #Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_correlation(self):
        # Prepare data
        query_graph = query_graph_for_correlation()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show the last name of student and the first name of student who has pet whose age is less than 10 and whose type is among the type of pet whose owner id is advisor of student"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        # Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_group_by_having(self):
        # Prepare data
        query_graph = query_graph_for_group_by_having()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        # gold_NL = "For each type of pets having the number of pets is greater than 2, show the number of student id student whose age is greater than 10"
        gold_NL = "Show number of student id for student whose age is less than 10 and who has pets for each petType of pets having number of pets is less than 2"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        #Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_order_by_limit(self):
        # Prepare data
        query_graph = query_graph_for_order_by_limit()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show top 10 first name of student order by age of student in descending order"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        #Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_multi_predicate_with_or(self):
        # Prepare data
        query_graph = query_graph_for_multi_predicate_with_or()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show first name of student for student whose department is equal to creative IT or student whose department is equal to computer science and student whose age is less than 20 or student whose age is greater than 25"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        #Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_multi_sublink_and_nested_sublink(self):
        # Prepare data
        query_graph = query_graph_for_multi_sublink_and_nested_sublink()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show first name of student for student with the same department as student for pets whose type is equal to dog and student whose average age is greater than the age of student for student whose department is equal to computer science"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]
        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]
        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]
        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)
        # Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))

    def test_multiple_projection_from_different_relations(self):
        # Prepare data
        query_graph = query_graph_for_multi_projection_from_different_relations()
        templates = self.templates
        selected_templates = template_selection(query_graph, templates)
        gold_NL = "Show name of student and name of their pets for student whose department is equal to computer science and pets whose age is greater than 10"
        # Add edges to attribute: query_graph_path
        selected_templates = [Template_instance.add_edge_to_query_graph_path(template, query_graph) for template in selected_templates]

        # Create mapping to perform template composition
        [template.create_template_to_query_graph_idx_mapping() for template in selected_templates]

        # Add schema template
        [template.add_schema_template(schema_template) for template in selected_templates]

        # NL Composition
        composed_NL = template_composition(selected_templates, query_graph.root)

        # Eval
        print(composed_NL)
        self.assertTrue(gold_NL == composed_NL, self.error_message_for_comparison(gold_NL, composed_NL))


if __name__ == "__main__":
    unittest.main()
