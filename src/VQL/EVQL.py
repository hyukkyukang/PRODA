import abc
import copy
from enum import IntEnum
from typing import List

import src.VQL.utils as utils
from src.table_excerpt.table_excerpt import TableExcerpt


class Operator(IntEnum):
    equal = 1
    lessThan = 2
    greaterThan = 3
    exists = 4
    notExists = 5

    @staticmethod
    def from_str(op_type: str) -> IntEnum:
        op_type = op_type.lower()
        if op_type == "=":
            return Operator.equal
        elif op_type == "<":
            return Operator.lessThan
        elif op_type == ">":
            return Operator.greaterThan
        elif op_type == "EXISTS":
            return Operator.exists
        elif op_type == "NOT EXISTS":
            return Operator.notExists
        else:
            raise ValueError(f"Unknown operator type: {op_type}")

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
    def add_idx_prefix(index: int) -> str:
        return f"${index}"

    @staticmethod
    def rm_prefix(value: str) -> int:
        return int(value[1:])

    @staticmethod
    def is_column_idx(idx: str) -> bool:
        return type(idx) == str and idx.startswith("$")

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
            # Assumption:
            #   1. right can be a column when the condition is for correlation
            #   2. alias is always used in correlation
            if is_string_value(right) and not utils.is_alias(right):
                right = f"'{right}'"
            return f"{left} {Operator.to_str(operator)} {right}"


class Aggregator(IntEnum):
    count = 1
    sum = 2
    avg = 3
    min = 4
    max = 5

    @staticmethod
    def to_str(agg_type: IntEnum) -> str:
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

    @staticmethod
    def from_str(agg_type: str) -> IntEnum:
        agg_type_lower = agg_type.lower()
        if agg_type_lower == "count":
            return Aggregator.count
        elif agg_type_lower == "sum":
            return Aggregator.sum
        elif agg_type_lower == "avg":
            return Aggregator.avg
        elif agg_type_lower == "min":
            return Aggregator.min
        elif agg_type_lower == "max":
            return Aggregator.max
        else:
            raise ValueError(f"Unknown aggregator: {agg_type}")


class Header:
    def __init__(self, id, agg_type=None):
        self.id = id
        self.agg_type = agg_type

    def __eq__(self, other):
        assert isinstance(other, Header), f"expected type Header but found: {type(other)}"
        return self.id == other.id and self.agg_type == other.agg_type

    @property
    def is_agg(self):
        return bool(self.agg_type)

    def dump_json(self):
        return {"id": self.id, "agg_type": self.agg_type}

    @staticmethod
    def load_json(json_obj):
        return Header(json_obj["id"], json_obj["agg_type"])


class Projection:
    def __init__(self, headers: List[Header] = None):
        self.headers: List[Header] = headers if headers else []

    def __eq__(self, other):
        assert isinstance(other, Projection), f"Expected type Projection, but found {type(other)}"
        return all([header in other.headers for header in self.headers])

    def dump_json(self):
        return {"headers": [header.dump_json() for header in self.headers]}

    @property
    def headers_with_agg(self):
        return [header for header in self.headers if header.is_agg]

    @staticmethod
    def load_json(json_obj):
        return Projection([Header.load_json(header) for header in json_obj["headers"]])


class Function(metaclass=abc.ABCMeta):
    def __init__(self, header_id):
        self.header_id = header_id

    def __eq__(self, other):
        assert isinstance(other, Function), f"Expected type of Function, but found: {type(other)}"
        if type(self) != type(other):
            return False
        return self.header_id == other.header_id

    def dump_json(self):
        return {"header_id": self.header_id, "func_type": type(self).__name__}

    @property
    def used_columns(self):
        return [self.header_id]

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
        self.is_ascending = is_ascending

    def __eq__(self, other):
        assert isinstance(other, Function), f"Expected type Ordering, but found: {type(other)}"
        if type(other) != Ordering:
            return False
        return self.header_id == other.header_id and self.is_ascending == other.is_ascending

    def dump_json(self):
        json_obj = super().dump_json()
        json_obj["is_ascending"] = self.is_ascending
        return json_obj


class Grouping(Function):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)


class Selecting(Function):
    def __init__(self, header_id, op_type, r_operand):
        self.header_id = header_id
        self.op_type = op_type
        # Can be either a value or header_id
        self.r_operand = r_operand

    def __eq__(self, other):
        assert isinstance(other, Function), f"Expected type Selecting, but found: {type(other)}"
        if type(other) != Selecting:
            return False
        return self.header_id == other.header_id and self.op_type == other.op_type and self.r_operand == other.r_operand

    @property
    def used_columns(self):
        if type(self.r_operand) == int:
            return [self.header_id, self.r_operand]
        return [self.header_id]

    def dump_json(self):
        json_obj = super().dump_json()
        json_obj["op_type"] = int(self.op_type)
        json_obj["r_operand"] = self.r_operand
        return json_obj


class Predicate:
    def __init__(self, clauses=None):
        self.clauses: List[Clause] = clauses if clauses else []

    def __eq__(self, other):
        assert isinstance(other, Predicate), f"Expected type Predicate, but found: {type(other)}"
        return all(clause in other.clauses for clause in self.clauses)

    def __len__(self):
        return len(self.clauses)

    @staticmethod
    def load_json(json_obj):
        return Predicate([Clause.load_json(clause) for clause in json_obj["clauses"]])

    @property
    def columns_for_grouping(self):
        tmp = []
        for clause in self.clauses:
            tmp += clause.columns_for_grouping
        return tmp

    @property
    def used_columns(self):
        tmp = []
        for clause in self.clauses:
            tmp += clause.used_columns
        return tmp

    # Helper functions
    def add(self, clause):
        self.clauses.append(clause)

    def dump_json(self):
        if self.clauses:
            return {"clauses": [clause.dump_json() for clause in self.clauses]}
        else:
            return {"clauses": [Clause().dump_json()]}


class Clause:
    def __init__(self, conditions=None):
        self.conditions: List[Function] = conditions if conditions else []

    def __eq__(self, other):
        assert isinstance(other, Clause), f"Expected type Clause, but found: {type(other)}"
        return all(condition in other.conditions for condition in self.conditions)

    @staticmethod
    def load_json(json_obj):
        return Clause([Function.load_json(condition) for condition in json_obj["conditions"]])

    @property
    def columns_for_grouping(self):
        return [condition.header_id for condition in self.conditions if type(condition) == Grouping]

    @property
    def used_columns(self):
        tmp = []
        for condition in self.conditions:
            tmp += condition.used_columns
        return tmp

    def __len__(self):
        return len(self.conditions)

    def add(self, condition):
        self.conditions.append(condition)

    def dump_json(self):
        return {"conditions": [condition.dump_json() for condition in self.conditions]}


class EVQLNode:
    def __init__(self, name, table_excerpt):
        self.name = name
        self.table_excerpt = table_excerpt
        self._projection = Projection()
        # Predicates follow DNF form. Hence, within each clause, conditions are joined with AND.
        self._predicate = Predicate()

    def __eq__(self, other):
        assert isinstance(other, EVQLNode), f"Expected type EVQLNode, but found:{type(EVQLNode)}"
        return self.predicate == other.predicate and self.projection == other.projection

    @staticmethod
    def to_table_excerpt_header_idx(evql_header_idx):
        return evql_header_idx - 1

    @staticmethod
    def load_json(json_obj):
        obj = EVQLNode(json_obj["name"], TableExcerpt.load_json(json_obj["table_excerpt"]))
        # Non-primitive types
        for header in Projection.load_json(json_obj["projection"]).headers:
            obj.add_projection(header)
        for clause in Predicate.load_json(json_obj["predicate"]).clauses:
            obj.add_predicate(clause)
        return obj

    # Basic property
    @property
    def projection(self):
        return self._projection

    @property
    def predicate(self):
        return self._predicate

    @property
    def headers(self):
        return [self.table_excerpt.name] + self.table_excerpt.headers

    # Helper functions
    def get_header_name(self, header: Header):
        return self.headers[header.id]

    def add_projection(self, header):
        self._projection.headers.append(header)

    def add_predicate(self, clause):
        self._predicate.clauses.append(clause)

    def dump_json(self):
        # Dump in json format to pass to web clients
        json_obj = {}
        json_obj["name"] = self.name
        json_obj["table_excerpt"] = self.table_excerpt.dump_json()
        json_obj["projection"] = self.projection.dump_json()
        json_obj["predicate"] = self.predicate.dump_json()
        json_obj["headers"] = self.headers
        return json_obj


class EVQLTree:
    def __init__(self, node, children=None):
        self.node: EVQLNode = node
        self.children: List[EVQLTree] = children if children else []

    def __eq__(self, other):
        assert isinstance(other, EVQLTree), f"Expected type EVQLTree, but found: {type(other)}"
        return self.node == other.node and all(child in other.children for child in self.children)

    @property
    def table_name(self):
        if self.children:
            return self.children[0].table_name
        return self.node.table_excerpt.name

    @property
    def level(self):
        return max([child.level for child in self.children]) + int(not self.is_having) if self.children else 1

    @property
    def is_groupby(self):
        return any([isinstance(cond, Grouping) for clause in self.node.predicate.clauses for cond in clause.conditions])

    @property
    def is_having(self):
        """Assumption: only one condition and one child on the having clause
        If there is a child and current node has selection on aggregated projection from the child node"""
        if len(self.children) != 1 or len(self.node.predicate) != 1 or len(self.node.predicate.clauses[0]) != 1:
            return False
        child = self.children[0]
        child_is_group_by = child.is_groupby
        child_projection_headers_with_agg = list(
            map(child.node.get_header_name, child.node.projection.headers_with_agg)
        )
        if child_is_group_by and child_projection_headers_with_agg:
            # Check two conditions:
            #   1. operator should be of selection excluding Exists and NotExists
            #   2. operand column should be of projection header (w/ agg) from child node
            for clause in self.node.predicate.clauses:
                for op in clause.conditions:
                    if isinstance(op, Selecting) and op.op_type not in [Operator.exists, Operator.notExists]:
                        # Set true and stop iteration if find matching
                        header_name = self.node.headers[op.header_id]
                        if header_name in child_projection_headers_with_agg:
                            return True
        return False

    @property
    def is_nested(self):
        return bool(self.children) and not self.is_having

    @property
    def header_ids_for_correlation(self):
        """Check if has correlation: if current node has selection on columns that are used for grouping in the children nodes
        Assumption: table_excerpts are accumulated for nested queries"""
        # Get all grouping columns in children
        column_names_for_grouping = []
        for child in self.children:
            column_ids_for_grouping = child.node.predicate.columns_for_grouping
            column_names_for_grouping += [child.node.headers[idx] for idx in column_ids_for_grouping]
        return [
            col_id
            for col_id in self.node.predicate.used_columns
            if self.node.headers[col_id] in column_names_for_grouping
        ]

    @property
    def is_nested_with_correlation(self):
        return self.is_nested and bool(self.header_ids_for_correlation)

    @property
    def to_sql(self):
        return evql_tree_to_SQL(self)

    @property
    def use_t_alias(self):
        return self.is_nested_with_correlation or any([child.use_t_alias for child in self.children])

    def get_var_name(self, header_idx, level_offset=0, use_t_alias=False):
        var_name = self.node.headers[header_idx] if header_idx else "*"
        return f"T{self.level-level_offset}.{var_name}" if self.use_t_alias or use_t_alias else var_name

    def get_child_var_name_for_correlation(self, header_idx):
        """Assumption: correlation only happens with the parent node and the alias simply plus one"""
        return self.get_var_name(header_idx, level_offset=1, use_t_alias=True)

    def dump_json(self):
        return {
            "node": self.node.dump_json(),
            "children": [child.dump_json() for child in self.children],
        }

    @staticmethod
    def load_json(json_obj):
        return EVQLTree(
            EVQLNode.load_json(json_obj["node"]), [EVQLTree.load_json(child) for child in json_obj["children"]]
        )


def evql_tree_to_SQL(evql_tree, correlation_cond_str=None):
    def create_select_clause(tree):
        att_str_list = []
        # Create string for every projecting headers
        for header in tree.node.projection.headers:
            hid = header.id
            att_str = tree.get_var_name(hid, use_t_alias=bool(correlation_cond_str))
            if header.is_agg:
                att_str = f"{Aggregator.to_str(header.agg_type)}({att_str})"
            # Save string to list
            att_str_list.append(att_str)
        # Get all headers for grouping as well
        # if not bool(correlation_cond_str):
        #     for hid in tree.node.predicate.columns_for_grouping:
        #         att_str_list.append(tree.get_var_name(hid, use_t_alias=bool(correlation_cond_str)))
        return f"SELECT {', '.join(att_str_list)}"

    def create_clause_str(formatted_conditions):
        def to_value(operand):
            return operand

        clause_str_list = []
        for l_op, op, r_op in formatted_conditions:
            clause_str_list.append(Operator.format_expression(to_value(l_op), op, to_value(r_op)))
        return " AND ".join(clause_str_list)

    def get_formatted_selection(tree):
        """Assumption: following disjunctive normal form"""
        """ return: List of List of triple of (left_operand_str, operator, right_operand_str)"""
        formatted_clause_list = []
        for clause in tree.node.predicate.clauses:
            correlation_mapping = {}
            for sel_cond in filter(lambda cond: isinstance(cond, Selecting), clause.conditions):
                if Operator.is_column_idx(sel_cond.r_operand):
                    r_col_idx = Operator.rm_prefix(sel_cond.r_operand)
                    # should be nested for correlation
                    if tree.node.table_excerpt.is_nested_col(EVQLNode.to_table_excerpt_header_idx(r_col_idx)):
                        # Get child that belongs to the r_operand
                        base_table_name = tree.node.table_excerpt.base_table_names[
                            EVQLNode.to_table_excerpt_header_idx(r_col_idx)
                        ]
                        children_of_base_table = [
                            child for child in tree.children if child.node.name == base_table_name
                        ]
                        assert (
                            len(children_of_base_table) == 1
                        ), f"Assumption: only one child for each base table, but found: {len(children_of_base_table)}"
                        node_of_base_table = children_of_base_table[0].node
                        # Get the name of the column
                        header_name = tree.node.headers[r_col_idx]
                        # Get grouping header ids of the child node
                        grouping_column_ids = node_of_base_table.predicate.columns_for_grouping
                        grouping_column_names = [node_of_base_table.headers[id] for id in grouping_column_ids]
                        if header_name in grouping_column_names:
                            # Create SQL condition
                            grouping_column_id = grouping_column_ids[grouping_column_names.index(header_name)]
                            formatted_cond = (
                                tree.get_child_var_name_for_correlation(grouping_column_id),
                                sel_cond.op_type,
                                tree.get_var_name(sel_cond.header_id, bool(correlation_cond_str)),
                            )
                            correlation_condition = create_clause_str([formatted_cond])
                            # Save mapping for later use
                            correlation_mapping[base_table_name] = correlation_condition

            formatted_cond_list = []
            # Filter conditions for correlation
            for sel_cond in filter(lambda cond: isinstance(cond, Selecting), clause.conditions):
                # Format operation
                l_op_str = tree.get_var_name(sel_cond.header_id, use_t_alias=bool(correlation_cond_str))
                op_str = sel_cond.op_type
                if Operator.is_column_idx(sel_cond.r_operand):
                    r_col_idx = Operator.rm_prefix(sel_cond.r_operand)
                    # TODO: Handling of previous results
                    # If nested and is grouped by
                    #                           : -> having
                    #                           : -> correlation selection on the inner query
                    # If nested and is not grouped by
                    #                           : -> create nested query and use it as an operand
                    if tree.node.table_excerpt.is_nested_col(EVQLNode.to_table_excerpt_header_idx(r_col_idx)):
                        # Get child that belongs to the r_operand
                        base_table_name = tree.node.table_excerpt.base_table_names[
                            EVQLNode.to_table_excerpt_header_idx(r_col_idx)
                        ]
                        children_of_base_table = [
                            child for child in tree.children if child.node.name == base_table_name
                        ]
                        assert (
                            len(children_of_base_table) == 1
                        ), f"Assumption: only one child for each base table, but found: {len(children_of_base_table)}"
                        child_of_base_table = children_of_base_table[0]
                        # Get the name of the column
                        header_name = tree.node.headers[r_col_idx]
                        # Get grouping header ids of the child node
                        grouping_column_ids = child_of_base_table.node.predicate.columns_for_grouping
                        grouping_column_names = [child_of_base_table.node.headers[id] for id in grouping_column_ids]
                        if header_name in grouping_column_names:
                            continue
                        # If need correlation, pass correlation condition to the child
                        correlation_condition = None
                        if base_table_name in correlation_mapping:
                            correlation_condition = correlation_mapping[base_table_name]
                        r_op_str = (
                            f"({evql_tree_to_SQL(child_of_base_table, correlation_cond_str=correlation_condition)})"
                        )
                    else:
                        r_op_str = tree.get_var_name(r_col_idx, use_t_alias=bool(correlation_cond_str))
                else:
                    r_op_str = sel_cond.r_operand
                # Append to list
                formatted_cond_list.append((l_op_str, op_str, r_op_str))
            if formatted_cond_list:
                formatted_clause_list.append(formatted_cond_list)
        return formatted_clause_list

    def create_where_clause(tree):
        formatted_clause_list = get_formatted_selection(tree)
        clause_str_list = list(map(create_clause_str, formatted_clause_list))
        # Add correlation condition to the list (inject into DNF)
        if correlation_cond_str:
            if clause_str_list:
                clause_str_list = [f"{correlation_cond_str} AND {clause_str}" for clause_str in clause_str_list]
            else:
                clause_str_list = [correlation_cond_str]
        prefix = " WHERE"

        if len(clause_str_list) > 1:
            return f"{prefix} ({') OR ('.join(clause_str_list)})"
        elif len(clause_str_list) == 1:
            return f"{prefix} {clause_str_list[0]}"
        return ""

    def create_order_by_clause(tree):
        # Get all attribute strings for ordering
        ordering_ops = []
        for clause in tree.node.predicate.clauses:
            ordering_ops += [cond for cond in clause.conditions if isinstance(cond, Ordering)]
        att_str_list = [
            f" {tree.get_var_name(op.header_id, use_t_alias=bool(correlation_cond_str))} {'ASC' if op.is_ascending else 'DESC'}"
            for op in ordering_ops
        ]
        return f" order by{','.join(att_str_list)}" if att_str_list else ""

    def create_group_by_clause(tree):
        # Get all attribute strings for grouping
        grouping_ops = []
        for clause in tree.node.predicate.clauses:
            grouping_ops += [cond for cond in clause.conditions if isinstance(cond, Grouping)]
            # for cond in clause.conditions:
            #     grouping_ops += [op for op in cond.operations if isinstance(op, Grouping)]
        return (
            f" group by {','.join([tree.get_var_name(op.header_id, use_t_alias=bool(correlation_cond_str)) for op in grouping_ops])}"
            if grouping_ops
            else ""
        )

    def create_from_clause(tree):
        """tree.use_t_alias covers outer queries, but it does not cover the most inner query
        correlation_cond_str is for the most inner query"""
        postfix = f" AS T{tree.level}" if tree.use_t_alias or bool(correlation_cond_str) else ""
        return f" FROM {tree.table_name}{postfix}"

    def create_having_clause(tree):
        def get_agg_func_name_from_prev_node(tree, col_name):
            """Find out aggregation operator from the previous EVQL projection"""
            assert len(tree.children) == 1, f"Expected only one child, but got {len(tree.children)}"
            child = tree.children[0]
            prev_node = child.node
            prev_headers = prev_node.headers
            col_id = prev_headers.index(col_name)
            prev_projection_headers = prev_node.projection.headers
            for projected_header in prev_projection_headers:
                if projected_header.id == col_id:
                    return Aggregator.to_str(projected_header.agg_type)
            raise RuntimeError(f"Cannot find aggregation function for column: {col_name}")

        def create_clause_str(formatted_conditions):
            formatted_cond_str_list = []
            for l_op, op, r_op in formatted_conditions:
                # Normalize column name (i.e. remove alias)
                col_name_wo_alias = utils.remove_alias(l_op) if utils.is_alias(l_op) else l_op
                # Search for agg func applied in the child node
                agg_func_name = get_agg_func_name_from_prev_node(tree, col_name_wo_alias)
                l_op = "*" if tree.node.headers.index(col_name_wo_alias) == 0 else l_op
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
        where_clause = create_where_clause(evql_tree.children[0])
        group_by_clause = create_group_by_clause(evql_tree.children[0]) if not correlation_cond_str else ""
        having_clause = create_having_clause(evql_tree)
    else:
        where_clause = create_where_clause(evql_tree)
        group_by_clause = create_group_by_clause(evql_tree) if not correlation_cond_str else ""
        having_clause = ""

    # Return composed SQL string
    return compose_clauses(select_clause, from_clause, where_clause, group_by_clause, having_clause, order_by_clause)


# Helper Functions
def check_evql_equivalence(evqlTree1: EVQLTree, evqlTree2: EVQLTree) -> bool:
    def check_and_remove_same_header(target_proj_header: Header, proj_headers: List[Header]):
        """Check if there are any same header and remove from the list if found"""
        found_idx = None
        # Find the matching index
        for idx, proj_header in enumerate(proj_headers):
            if proj_header == target_proj_header:
                found_idx = idx
        # Remove from list if found
        if found_idx is not None:
            proj_headers.pop(found_idx)
        return found_idx is not None

    # Check num of
    if evqlTree1.children and len(evqlTree1.children) == len(evqlTree2.children):
        is_same_children = all(
            check_evql_equivalence(child1, child2) for child1, child2 in zip(evqlTree1.children, evqlTree2.children)
        )
    else:
        is_same_children = not bool(evqlTree1.children)

    # Check headers
    is_same_headers = evqlTree1.node.headers[1:] == evqlTree2.node.headers[1:]

    # Check predicate
    is_same_predicate = evqlTree1.node.predicate == evqlTree2.node.predicate

    # Check projection
    # is_same_projection = True
    # tmp_header_list = copy.deepcopy(evqlTree2.node.projection.headers)
    # for header in evqlTree1.node.projection.headers:
    #     is_same_projection &= check_and_remove_same_header(header, tmp_header_list)
    # is_same_projection &= len(tmp_header_list) == 0
    is_same_projection = evqlTree1.node.projection == evqlTree2.node.projection

    # Check is_groupby
    is_same_groupby = evqlTree1.is_groupby == evqlTree2.is_groupby

    # Check is_having
    is_same_having = evqlTree1.is_having == evqlTree2.is_having

    # Check is_nested
    is_same_nested = evqlTree1.is_nested == evqlTree2.is_nested

    # Check is_nested_with_correlation
    is_same_correlated_nesting = evqlTree1.is_nested_with_correlation == evqlTree2.is_nested_with_correlation

    # Check level
    is_same_level = evqlTree1.level == evqlTree2.level

    return all(
        [
            is_same_children,
            is_same_headers,
            is_same_predicate,
            is_same_projection,
            is_same_groupby,
            is_same_having,
            is_same_nested,
            is_same_correlated_nesting,
            is_same_level,
        ]
    )


if __name__ == "__main__":
    pass
    # import json
    # from tests.EVQL.utils import SelectionQueryWithOr
    # query = SelectionQueryWithOr()
    # dumped_query = query.evql.dump_json()
    # print(json.dumps(dumped_query, indent=4))
    # evql_tree = EVQLTree.load_json(dumped_query)
    # assert evql_tree.to_sql == query.evql.to_sql
