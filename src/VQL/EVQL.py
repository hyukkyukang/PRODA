import abc
import typing

from enum import IntEnum
from src.table.table import Table

class Operator(IntEnum):
    equal = 1
    lessThan = 2
    greaterThan = 3
    exists = 4
    notExists = 5

    @staticmethod
    def to_str(op_type):
        if op_type == Operator.equal:
            return "="
        elif op_type == Operator.lessThan:
            return "<"
        elif op_type == Operator.greaterThan:
            return ">"
        elif op_type == Operator.exists:
            return "EXISTS"
        elif op_type == Operator.notExists:
            return "NOT EXISTS"
        else:
            raise ValueError(f"Unknown operator type: {op_type}")

    @staticmethod
    def format_expression(left, operator, right):
        def is_string_value(operand):
            try:
                float(operand)
                return False
            except:
                return "select " not in operand.lower()
        if operator in [Operator.exists, Operator.notExists]:
            assert right is None, "EXISTS and NOT EXISTS are uniary operators"
            return f"{Operator.to_str(operator)} {left}"
        else:
            right = f"'{right}'" if is_string_value(right) else right
            return f"{left} {Operator.to_str(operator)} {right}"

class Aggregator(IntEnum):
    count = 1
    sum = 2
    avg = 3
    min = 4
    max = 5

    @staticmethod
    def to_str(agg_type):
        if agg_type == Aggregator.count:
            return "COUNT"
        elif agg_type == Aggregator.sum:
            return "SUM"
        elif agg_type == Aggregator.avg:
            return "AVG"
        elif agg_type == Aggregator.min:
            return "MIN"
        elif agg_type == Aggregator.max:
            return "MAX"
        else:
            raise ValueError(f"Unknown aggregator: {agg_type}")

class Projection():
    def __init__(self, headers=None):
        self.headers = headers if headers else []
        
    def dump_json(self):
        return {"headers": [header.dump_json() for header in self.headers]}

    @staticmethod
    def load_json(json_obj):
        return Projection([Header.load_json(header) for header in json_obj["headers"]])

class Header():
    def __init__(self, id, agg_type=None):
        self.id = id
        self.agg_type = agg_type

    @property
    def is_agg(self):
        return bool(self.agg_type)
    
    def dump_json(self):
        return {"id": self.id, "agg_type": self.agg_type}
    
    @staticmethod
    def load_json(json_obj):
        return Header(json_obj["id"], json_obj["agg_type"])

class Function(metaclass=abc.ABCMeta):
    def __init__(self, header_id):
        self.header_id = header_id

    def dump_json(self):
        return {"header_id": self.header_id, "func_type": type(self).__name__}
    
    @staticmethod
    def load_json(json_obj):
        if json_obj["func_type"] == "Ordering":
            return Ordering(json_obj["header_id"], json_obj["is_ascending"])
        elif json_obj["func_type"] == "Grouping":
            return Grouping(json_obj["header_id"])
        elif json_obj["func_type"] == "Selecting":
            return Selecting(json_obj["header_id"], json_obj["op_type"], json_obj["r_operand"])
        return Function(json_obj["header_id"])

class Ordering(Function):
    def __init__(self, header_id, is_ascending=True):
        super().__init__(header_id)
        self.is_ascending=is_ascending
        
    def dump_json(self):
        json_obj = super().dump_json()
        json_obj["is_ascending"] = self.is_ascending
        return json_obj

class Grouping(Function):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

class Selecting(Function):
    def __init__(self, l_header_id, op_type, r_operand):
        self.header_id = l_header_id
        self.op_type = op_type
        # Can be either a value or header_id
        self.r_operand = r_operand 

    def dump_json(self):
        json_obj = super().dump_json()
        json_obj["op_type"] = int(self.op_type)
        json_obj["r_operand"] = self.r_operand
        return json_obj

class Predicate():
    def __init__(self, clauses=None):
        self.clauses = clauses if clauses else []

    def add(self, clause):
        self.clauses.append(clause)

    def dump_json(self):
        if self.clauses:
            return {"clauses": [clause.dump_json() for clause in self.clauses]}
        else:
            return {"clauses": [Clause().dump_json()]}

    @staticmethod
    def load_json(json_obj):
        return Predicate([Clause.load_json(clause) for clause in json_obj["clauses"]])

class Clause():
    def __init__(self, conditions=None):
        self.conditions = conditions if conditions else []
        
    def add(self, condition):
        self.conditions.append(condition)

    def dump_json(self):
        return {"conditions":[condition.dump_json() for condition in self.conditions]}

    @staticmethod
    def load_json(json_obj):
        return Clause([Function.load_json(condition) for condition in json_obj["conditions"]])

class EVQLNode():
    def __init__(self, table_excerpt, header_aliases=None, foreach_col_id=None):
        self.table_excerpt = table_excerpt
        self.header_aliases = header_aliases if header_aliases else table_excerpt.table_excerpt_headers
        self.foreach = foreach_col_id
        self._projection = Projection()
        # Predicates follow DNF form. Hence, within each clause, conditions are joined with AND.
        self._predicate = Predicate()

    @property
    def projection(self):
        return self._projection

    @property
    def predicate(self):
        return self._predicate

    def add_projection(self, header):
        self._projection.headers.append(header)

    def add_predicate(self, clause):
        self._predicate.clauses.append(clause)

    def dump_json(self):
        json_obj = {}
        json_obj["table_excerpt"] = self.table_excerpt.dump_json()
        json_obj["header_aliases"] = self.header_aliases
        json_obj["foreach"] = self.foreach
        json_obj["projection"] = self.projection.dump_json()
        json_obj["predicate"] = self.predicate.dump_json()
        return json_obj

    @staticmethod
    def load_json(json_obj):
        obj = EVQLNode(Table.load_json(json_obj["table_excerpt"]), json_obj["header_aliases"], json_obj["foreach"])
        # Non-primitive types
        for header in Projection.load_json(json_obj["projection"]).headers:
            obj.add_projection(header)
        for clause in Predicate.load_json(json_obj["predicate"]).clauses:
            obj.add_predicate(clause)
        return obj

class EVQLTree:
    def __init__(self, node, children=None, enforce_t_alias=False):
        self.node: EVQLNode = node
        self.children: typing.List[EVQLTree]= children if children else []
        self.enforce_t_alias = enforce_t_alias

    @property
    def level(self):
        def find_max_depth(tree):
            depths = [find_max_depth(item) for item in tree.children if isinstance(item, EVQLTree)]
            num_to_add = 0 if tree.is_having else 1
            return max(depths) + num_to_add if depths else 1
        return find_max_depth(self)

    @property
    def is_groupby(self):
        return any([isinstance(cond, Grouping) for clause in self.node.predicate.clauses for cond in clause.conditions])

    @property
    def is_having(self):
        """ Assumption: only one condition on the having clause"""
        child_is_group_by = len(self.children) == 1 and self.first_child.is_groupby
        child_projects_aggregated_value = len(self.children) and len(self.first_child.node.projection.headers) == 2 and any([proj.is_agg for proj in self.first_child.node.projection.headers])
        if child_is_group_by and child_projects_aggregated_value:
            has_selection_on_aggregated_value = False
            child = self.first_child.node
            # Check two conditions:
            #   1. condition only on aggregated value (i.e. output from the previous group by query)
            #   2. operator should not be a set operator (e.g. exists, not exists)
            for clause in self.node.predicate.clauses:
                for op in clause.conditions:
                    # Condition 1
                    if op.header_id < len(child.table_excerpt.table_excerpt_headers):
                        return False
                    elif isinstance(op, Selecting):
                        # Condition 2
                        if op.op_type in [Operator.exists, Operator.notExists]:
                            return False
                        else:
                            has_selection_on_aggregated_value = True
            return has_selection_on_aggregated_value
        return False

    @property
    def is_nested(self):
        return bool(self.children) and not self.is_having

    @property
    def is_nested_with_correlation(self):
        return self.is_nested and bool(self.first_child.node.foreach)

    @property
    def to_sql(self):
        return evql_tree_to_SQL(self)

    @property
    def use_t_alias(self):
        return self.node.foreach or any([child.use_t_alias for child in self.children]) or self.enforce_t_alias

    @property
    def first_child(self):
        return self.children[0] if self.children else None

    def get_var_name(self, header_idx):
        var_name = self.node.table_excerpt.table_excerpt_headers[header_idx] if header_idx else "*"
        return f"T{self.level}.{var_name}" if self.use_t_alias else var_name

    def get_parent_var_name_for_correlation(self, header_idx):
        """Assumption: correlation only happens with the parent node and the alias simply plus one"""
        var_name = self.node.table_excerpt.table_excerpt_headers[header_idx] if header_idx else "*"
        return f"T{self.level+1}.{var_name}" if self.use_t_alias else var_name

    def dump_json(self):
        return {
            "node": self.node.dump_json(),
            "children": [child.dump_json() for child in self.children],
            "enforce_t_alias": self.enforce_t_alias
        }
        
    @staticmethod
    def load_json(json_obj):
        return EVQLTree(EVQLNode.load_json(json_obj["node"]), [EVQLTree.load_json(c) for c in json_obj["children"]], json_obj["enforce_t_alias"])

def evql_tree_to_SQL(evql_tree):
    def create_select_clause(tree):
        att_str_list = []
        # Create string for every projecting headers
        for header in tree.node.projection.headers:
            hid = header.id
            att_str = tree.get_var_name(hid)
            if header.is_agg:
                att_str = f"{Aggregator.to_str(header.agg_type)}({att_str})"
            # Save string to list
            att_str_list.append(att_str)
        # Return select clause string
        return f"SELECT {', '.join(att_str_list)}"
    def get_formatted_selection(tree):
        """ Assumption: following disjunctive normal form"""
        """ return: List of List of triple of (left_operand_str, operator, right_operand_str)"""
        formatted_clause_list= []
        for clause in tree.node.predicate.clauses:
            formatted_cond_list = []
            for sel_cond in filter(lambda cond: isinstance(cond, Selecting), clause.conditions):
                # Format operation
                l_op_str = tree.get_var_name(sel_cond.header_id)
                op_str = sel_cond.op_type
                r_op_str = sel_cond.r_operand
                # Append to list
                formatted_cond_list.append((l_op_str, op_str, r_op_str))
            if formatted_cond_list:
                formatted_clause_list.append(formatted_cond_list)
        return formatted_clause_list
    def create_where_clause(tree, tree_for_correlation):
        def create_clause_str(formatted_conditions):
            def to_value(operand):
                if operand and (operand.startswith("$step") or ".step" in operand) and operand.count("_"):
                    assert len(tree.children) == 1, "Assumption: only one child"
                    operand = f"({evql_tree_to_SQL(tree.first_child)})"
                return operand
            clause_str_list = []
            for l_op, op, r_op in formatted_conditions:
                clause_str_list.append(Operator.format_expression(to_value(l_op), op, to_value(r_op)))
            return " AND ".join(clause_str_list)

        def get_correlation_cond_str(tree):
            cond = ""
            if tree.node.foreach:
                l_op = tree.get_var_name(tree.node.foreach)
                r_op = tree.get_parent_var_name_for_correlation(tree.node.foreach)
                cond = f"{l_op} = {r_op}"
            return cond

        formatted_clause_list = get_formatted_selection(tree)
        clause_str_list = list(map(create_clause_str, formatted_clause_list))
        # TODO: Problem when there are more conditions other than correlation. Need to conjunct with other expressions
        correlation_str = get_correlation_cond_str(tree_for_correlation)
        prefix = f" WHERE {correlation_str}" if correlation_str else " WHERE"

        if len(clause_str_list) > 1:
            return f"{prefix} ({') OR ('.join(clause_str_list)})"
        elif len(clause_str_list) == 1:
            return f"{prefix} {clause_str_list[0]}"
        elif correlation_str:
            return prefix
        return ""
    def create_order_by_clause(tree):
        # Get all attribute strings for ordering
        ordering_ops = []
        for clause in tree.node.predicate.clauses:
            ordering_ops += [cond for cond in clause.conditions if isinstance(cond, Ordering)]
        att_str_list = [f" {tree.get_var_name(op.header_id)} {'ASC' if op.is_ascending else 'DESC'}" for op in ordering_ops]
        return f" order by{','.join(att_str_list)}" if att_str_list else ""

    def create_group_by_clause(tree):
        # Get all attribute strings for grouping
        grouping_ops = []
        for clause in tree.node.predicate.clauses:
            grouping_ops += [cond for cond in clause.conditions if isinstance(cond, Grouping)]
            # for cond in clause.conditions:
            #     grouping_ops += [op for op in cond.operations if isinstance(op, Grouping)]
        return f" group by {','.join([tree.get_var_name(op.header_id) for op in grouping_ops])}" if grouping_ops else ""

    def create_from_clause(tree):
        postfix = f" AS T{tree.level}" if tree.use_t_alias else ""
        return f" FROM {tree.node.table_excerpt.table_excerpt_headers[0]}{postfix}"

    def create_having_clause(tree):
        def get_agg_func_name_from_prev_node(tree, col_name):
            """Find out aggregation operator from the previous EVQL projection"""
            prev_node = tree.children[0].node
            prev_headers = prev_node.header_aliases
            col_id = prev_headers.index(col_name)
            prev_projection_headers = prev_node.projection.headers
            for projected_header in prev_projection_headers:
                if projected_header.id == col_id:
                    return Aggregator.to_str(projected_header.agg_type)
            raise RuntimeError(f"Cannot find aggregation function for column: {col_name}")
        
        def create_clause_str(formatted_conditions):
            formatted_cond_str_list = []
            for l_op, op, r_op in formatted_conditions:
                agg_func_name = get_agg_func_name_from_prev_node(tree, l_op)
                l_op = "*" if tree.node.table_excerpt.table_excerpt_headers.index(l_op) == 0 else l_op
                l_op_att_str = f"{agg_func_name}({l_op})"
                formatted_cond_str_list.append(Operator.format_expression(l_op_att_str, op, r_op))
            return " AND ".join(formatted_cond_str_list)
        formatted_clause_list = get_formatted_selection(tree)
        clause_str_list = list(map(create_clause_str, formatted_clause_list))
        if len(clause_str_list) > 1:
            return f" HAVING ({') OR ('.join(clause_str_list)})"
        elif len(clause_str_list) == 1:
            return f" HAVING {clause_str_list[0]}"
        return ""

    def compose_clauses(select_clause, from_clause, where_clause, group_by_clause, having_clause, order_by_clause):
        def append_string(cumulated_str, new_str):
            return cumulated_str + new_str if new_str else cumulated_str
        sql_str = append_string(select_clause, from_clause)
        sql_str = append_string(sql_str, where_clause)
        sql_str = append_string(sql_str, group_by_clause)
        sql_str = append_string(sql_str, having_clause)
        sql_str = append_string(sql_str, order_by_clause)
        return sql_str

    # Create clauses
    select_clause = create_select_clause(evql_tree)
    from_clause = create_from_clause(evql_tree)
    order_by_clause = create_order_by_clause(evql_tree)
    if evql_tree.is_having:
        where_clause = create_where_clause(evql_tree.first_child, evql_tree)
        group_by_clause = create_group_by_clause(evql_tree.first_child)
        having_clause = create_having_clause(evql_tree)
    else:
        where_clause = create_where_clause(evql_tree, evql_tree)
        group_by_clause = create_group_by_clause(evql_tree)
        having_clause = ""

    # Return composed SQL string
    return compose_clauses(select_clause, from_clause, where_clause, group_by_clause, having_clause, order_by_clause)

if __name__ == "__main__":
    pass
    # import json
    # from tests.EVQL.utils import SelectionQueryWithOr
    # query = SelectionQueryWithOr()
    # dumped_query = query.evql.dump_json()
    # print(json.dumps(dumped_query, indent=4))
    # evql_tree = EVQLTree.load_json(dumped_query)
    # assert evql_tree.to_sql == query.evql.to_sql
