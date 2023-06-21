from __future__ import annotations

import copy
from enum import IntEnum
from typing import List, Optional, Tuple, Union

from src.pylogos.query_graph.koutrika_query_graph import Node, Predicate


class OperationType(IntEnum):
    Projection = 1
    Selection = 2
    Grouping = 3
    Having = 4
    Ordering = 5


def remove_number_in_string(string: str) -> str:
    if string is None:
        return ""
    return "".join([c for c in string if not c.isdigit()])


class SStrChar:
    """This is an string object to keep track of the origin of the string.
    Here, the origin means which table or column the string is created to describe.

    :param str: _description_
    :type str: _type_
    """

    def __init__(
        self,
        text: str,
        table_node: str,
        column_node: Optional[str] = None,
        op_type: Optional[OperationType] = None,
        is_table: bool = False,
    ):
        self.ori_label = text
        self.text: str = text
        self.table_node: str = table_node
        self.column_node: Optional[str] = column_node
        self.op_type: Optional[OperationType] = op_type
        self.is_table: bool = is_table

    def __str__(self):
        return self.text

    def __len__(self):
        return len(self.text)

    def __hash__(self):
        if self.is_table:
            return hash((self.text, self.table_node))
        return hash((self.text, self.table_node, self.column_node))

    def __eq__(self, other):
        if type(other) == SStrChar:
            return (
                self.text == other.text
                and self.table_node == other.table_node
                and ((self.is_table and other.is_table) or self.column_node == other.column_node)
            )
        return False

    def __bool__(self):
        return bool(self.text)

    @property
    def is_empty_string(self):
        return str(self) in ["", " "]

    def is_same_root(self, other):
        return (
            self.ori_label == other.ori_label
            and remove_number_in_string(self.table_node) == remove_number_in_string(other.table_node)
            and (
                (self.is_table and other.is_table)
                or remove_number_in_string(self.column_node) == remove_number_in_string(other.column_node)
            )
        )

    def add_prefix(self, prefix: str) -> None:
        self.text = prefix + self.text
        return self

    def add_suffix(self, suffix: str) -> None:
        self.text += suffix
        return self

    def startswith(self, other):
        return self.text.startswith(other)

    def endswith(self, other):
        return self.text.endswith(other)


class SStrWord:
    def __init__(self, items: List[SStrChar]):
        self.items: List[SStrChar] = copy.deepcopy(items)

    def __str__(self):
        return " ".join([str(sstr) for sstr in self.items])

    def __hash__(self):
        return hash(tuple(self.items))

    def __len__(self):
        return len(self.items)

    def __getitem__(self, idx):
        return self.items[idx]

    def __eq__(self, other):
        if type(other) == SStrWord:
            return all([sstr1 == sstr2 for sstr1, sstr2 in zip(self.items, other.items)])
        return False

    def __add__(self, other: SStrWord):
        if type(other) == SStrWord:
            return SStrWord(list(filter(lambda k: str(k) != "", self.items + other.items)))
        elif type(other) == SStrChar:
            return SStrWord(list(filter(lambda k: str(k) != "", self.items + [other])))
        raise TypeError(f"Cannot add {type(other)} to SStrs")

    def __bool__(self):
        return any(bool(item) for item in self.items)

    @property
    def is_empty_string(self):
        return str(self) in ["", " "]

    @staticmethod
    def create_empty_object():
        return SStrWord([SStrChar("", None)])

    def startswith(self, substring: str):
        return str(self).startswith(substring)

    def endswith(self, other):
        return self.items[-1].endswith(other)

    def is_same_root(cls, other):
        return all(sstr1.is_same_root(sstr2) for sstr1, sstr2 in zip(cls.items, other.items))

    def add_prefix(self, prefix: str) -> None:
        self.items[0].add_prefix(prefix)
        return self

    def add_suffix(self, suffix: str) -> None:
        self.items[-1].add_suffix(suffix)
        return self


class SStrSen:
    def __init__(self, items: List[SStrWord]):
        self.items: List[SStrWord] = copy.deepcopy(items)

    def __str__(self):
        return " ".join([str(sstr) for sstr in self.items])

    def __hash__(self):
        return hash(tuple(self.items))

    def __len__(self):
        return len(self.items)

    def __getitem__(self, idx):
        return self.items[idx]

    def __eq__(self, other):
        if type(other) == SStrSen:
            return all([sstr1 == sstr2 for sstr1, sstr2 in zip(self.items, other.items)])
        return False

    def __add__(self, other: SStrSen):
        if type(other) == SStrSen:
            return SStrSen(list(filter(lambda k: str(k) != "", self.items + other.items)))
        elif type(other) == SStrWord:
            return SStrSen(list(filter(lambda k: str(k) != "", self.items + [other])))
        elif type(other) == SStrChar:
            return SStrSen(list(filter(lambda k: str(k) != "", self.items + [SStrWord([other])])))
        raise TypeError(f"Cannot add {type(other)} to SStrs")

    def __bool__(self):
        return any(bool(item) for item in self.items)

    @property
    def is_empty_string(self):
        return str(self) in ["", " "]

    @staticmethod
    def create_empty_object():
        return SStrSen([SStrWord([SStrChar("", None)])])

    def startswith(self, substring: str):
        return str(self).startswith(substring)

    def endswith(self, other):
        return self.items[-1].endswith(other)

    def add_prefix(self, prefix: str) -> None:
        self.items[0].add_prefix(prefix)
        return self

    def add_suffix(self, suffix: str) -> None:
        self.items[-1].add_suffix(suffix)
        return self

    def combine_words(self):
        item = self.items[0]
        for i in range(1, len(self.items)):
            item += self.items[i]
        self.items = [item]
        return self

    def get_sentence_mapping(self):
        """Output string and json object mapping the phrase information to the sentence
        :return: _description_
        :rtype: tuple
        """
        mapping = []
        cnt = 0
        for i, sstr_word in enumerate(self.items):
            for j, sstr_char in enumerate(sstr_word.items):
                mapping.append(
                    {
                        "start": cnt,
                        "end": cnt + len(sstr_char),
                        "type": int(sstr_char.op_type) if sstr_char.op_type else None,
                        "table": sstr_char.table_node,
                        "column": sstr_char.column_node if sstr_char.column_node else None,
                    }
                )
                cnt += len(sstr_char)
                if j < len(sstr_word.items):
                    cnt += 1
        return mapping


class StringBuilder:
    def __init__(self, is_nested=False):
        self.is_nested: bool = is_nested
        self.projection: List[Tuple(Node, Node, str)] = []
        self.selection: List[Tuple(Node, Node, Node, Predicate, str, Optional[Node])] = []
        self.selection_dnf: List[List[Tuple(Node, Node, Node, Predicate, str, Optional[Node])]] = []
        self.grouping: List[Tuple(Node, Node, Node)] = []
        self.having: List[Tuple[Node, Node, Node, Node, Predicate, Node]] = []
        self.ordering: List[Tuple(Node, Node, str)] = []
        self.sentences: SStrSen = []
        self.join_conditions: List[Tuple(Node, Node, Predicate, Node, bool)] = []
        self.limit: int = None

    def description_of_rel(self, rel: SStrChar, desc: SStrSen, dont_use_of: bool = False) -> SStrSen:
        if rel:
            rel_sen = SStrSen([SStrWord([rel])])
            if desc.is_empty_string:
                return rel_sen
            elif dont_use_of:
                return desc + rel_sen
            else:
                return desc + rel_sen.add_prefix("of ")
        else:
            return desc

    def concate_by(self, texts: List[SStrSen], sep_str: str):
        new_str_sen = SStrSen.create_empty_object()
        for i, t in enumerate(texts):
            if not t.is_empty_string and not new_str_sen.is_empty_string:
                new_str_sen[-1].add_suffix(sep_str)
            new_str_sen += t
        return new_str_sen

    def concate_by_comma_and(self, texts: SStrSen) -> SStrSen:
        for i in range(len(texts)):
            if i < len(texts) - 1:  # not the last one
                if i < len(texts) - 2:  # for every non-last two items
                    texts[i].add_suffix(",")
                elif i == len(texts) - 2:  # for every second to last item
                    if len(texts) == 2:  # if there are only two items
                        texts[i].add_suffix(" and")
                    else:  # if there are more than two items
                        texts[i][-1].add_suffix(", and")
                else:
                    raise RuntimeError("Should not be here")
        return texts

    def construct_sentence(self) -> SStrSen:
        # text = ""
        text = SStrSen.create_empty_object()
        # we do not make
        target_relation = None
        while self.projection or self.selection:
            # Get target relation
            if self.projection:
                target_relation = self.projection[0][0]
            else:
                target_relation = self.selection[0][0]

            # Flags
            join_flag = False
            grouping_flag = False
            having_flag = False

            # Get projections for target relation
            if self.projection:
                tmp = []
                tmp_o = []
                texts = SStrSen.create_empty_object()
                for rel, att, agg in self.projection:
                    if rel == target_relation:
                        # Meta information
                        if not att.is_empty_string:
                            att_flag = True
                        # To string
                        cur_word = SStrWord(list(filter(lambda k: k, [agg, att])))
                        if self.ordering and att_flag:
                            for rp_o, rel_o, att_o in self.ordering:
                                if rel_o == target_relation and att_o == att:
                                    cur_word.add_suffix(" (in ascending order)")
                                else:
                                    tmp_o.append((rp_o, rel_o, att_o))
                            self.ordering = copy.deepcopy(tmp_o)
                        texts += cur_word
                    else:
                        tmp.append((rel, att, agg))

                # Natural concatenate
                ttmp = self.concate_by_comma_and(texts)
                if ttmp:
                    # Consider case where the label of the attribute is empty string
                    att_desc = self.description_of_rel(target_relation, ttmp, not att_flag)

                    text = self.concate_by([text, att_desc], ",")
                self.projection = tmp

            if self.grouping:
                # Begin sentence
                if not text:
                    text = SStrSen([SStrWord([target_relation])])

                tmp = []
                grouping_atts = {}
                for rp, rel, att in self.grouping:
                    if rp == target_relation:
                        grouping_atts[rel] = grouping_atts.get(rel, []) + [att]
                    else:
                        tmp.append((rp, rel, att))
                if grouping_atts:
                    grouping_flag = True
                    texts = SStrSen.create_empty_object()
                    for key_rel, att_list in grouping_atts.items():
                        # description of attributes in the att_list
                        atts_str = self.concate_by_comma_and(SStrSen([SStrWord([item]) for item in att_list]))
                        # Append to the string
                        texts += self.description_of_rel(key_rel, atts_str).combine_words()
                    text += self.concate_by_comma_and(texts).add_prefix("for each ")
                self.grouping = tmp

            if self.having:
                tmp = []
                texts = SStrSen.create_empty_object()
                for rp, rel, att, func, op, val in self.having:
                    if rp.is_same_root(target_relation):
                        having_flag = True
                        sub_words = SStrSen.create_empty_object()
                        att_sen = SStrSen([SStrWord([att])])
                        att_desc = self.description_of_rel(rel, att_sen)
                        for item in [func, att_desc, op, val]:
                            sub_words += item
                        texts += sub_words.combine_words()
                    else:
                        tmp.append((rp, rel, att, func, op, val))
                if texts:
                    text.add_suffix(",")
                    text += self.concate_by_comma_and(texts).add_prefix(f"considering only those groups whose ")
                self.having = tmp

            assert (
                grouping_flag or grouping_flag == having_flag
            ), f"HAVING must be used with GROUP BY, but {grouping_flag} != {having_flag}"

            # Get join_conditions for target relation
            if self.join_conditions:
                # Begin sentence
                if not text:
                    text = SStrSen([SStrWord([target_relation])])
                tmp = []
                texts = SStrSen.create_empty_object()
                for reference_point, rel1, edge, rel2, has_incoming_edge in self.join_conditions:
                    # Append to the string of reference point if it has no incoming edge
                    if not has_incoming_edge and reference_point == target_relation:
                        # Append if there is an edge or was an edge in the previous iteration
                        if edge or texts:
                            texts += SStrSen([SStrWord([edge, rel2])])
                            # texts += self.concate_by([edge, rel2], " ")
                            # Search for correlation condition in the selection
                            correlations_for_rel2 = [
                                sel
                                for sel in self.selection
                                if sel[0] != sel[1]
                                and sel[0] == target_relation
                                and sel[1].is_same_root(rel2)
                                and rel2 == sel[5]
                            ]
                            assert (
                                len(correlations_for_rel2) <= 1
                            ), f"the number of correlation conditions for {rel2} is {len(correlations_for_rel2)} > 1"
                            if correlations_for_rel2:
                                selected_correlation = correlations_for_rel2[0]
                                self.selection.remove(selected_correlation)
                                texts += selected_correlation[2].add_prefix("of the same ")
                                # texts[-1] += f" of the same {selected_correlation[2]}"

                    # Append to the string of rel1 if it has incoming edge
                    elif has_incoming_edge and rel1 == target_relation:
                        # Append if there is an edge or was an edge in the previous iteration
                        if edge or texts:
                            texts += SStrSen([SStrWord([edge, rel2])])
                            # texts += self.concate_by([edge, rel2], " ")
                    else:
                        tmp.append((reference_point, rel1, edge, rel2, has_incoming_edge))
                if texts:
                    join_flag = True
                    if having_flag:
                        text.add_suffix(",")
                    text += target_relation.add_prefix("in which ")
                    texts.combine_words()
                text += texts
                self.join_conditions = tmp

            # Get selection for target relation
            if self.selection:
                # Begin sentence
                if not text:
                    text = SStrSen([SStrWord([target_relation])])
                tmp = []
                texts = SStrSen.create_empty_object()
                # Handle selection for non-join relations
                for rp, rel, att, op, val, val_parent in self.selection:
                    if rp.is_same_root(target_relation):
                        # If attribute is an empty string
                        subwords = SStrSen.create_empty_object()
                        if type(val) == SStrSen:
                            val_desc = val
                        else:
                            val_desc = SStrSen([SStrWord([val])])
                        if val_parent:
                            val_desc += val_parent.add_prefix("of those ")
                        if att.is_empty_string and op.startswith("there"):
                            subwords += op
                            subwords += val_desc
                        else:
                            subwords += self.description_of_rel(rel, SStrSen([SStrWord([att])]))
                            subwords += op
                            subwords += val_desc
                        subwords.combine_words()
                        texts += subwords
                    else:
                        tmp.append((rp, rel, att, op, val, val_parent))
                if texts:
                    if join_flag:
                        text.add_suffix(" and")
                    else:
                        if having_flag:
                            text.add_suffix(",")
                        texts.add_prefix("where ")
                    text += self.concate_by_comma_and(texts)
                self.selection = tmp
        if self.sentences:
            text = self.concate_by([text] + self.sentences, ", and ")
        if self.limit:
            limit_text = SStrSen.create_empty_object()
            limit_text = limit_text.add_suffix("Find only " + str(self.limit) + " results")
            text = self.concate_by([text] + [limit_text], ". ")
        return text

    def construct_sentence_dnf(self) -> SStrSen:
        # text = ""
        text = SStrSen.create_empty_object()
        # we do not make
        target_relation = None
        while self.projection or self.selection:
            # Get target relation
            if self.projection:
                target_relation = self.projection[0][0]
            else:
                target_relation = self.selection[0][0]

            # Flags
            join_flag = False
            grouping_flag = False
            having_flag = False
            att_flag = False

            # Get projections for target relation
            if self.projection:
                tmp = []
                tmp_o = []
                texts = SStrSen.create_empty_object()
                for rel, att, agg in self.projection:
                    if rel == target_relation:
                        # Meta information
                        if not att.is_empty_string:
                            att_flag = True
                        # To string
                        cur_word = SStrWord(list(filter(lambda k: k, [agg, att])))
                        order_flag = False
                        if self.ordering and att_flag:
                            for rp_o, rel_o, att_o in self.ordering:
                                if rel_o == target_relation and att_o == att:
                                    if not order_flag:
                                        order_flag = True
                                        cur_word.add_suffix(" (in ascending order)")
                                    else:
                                        pass
                                else:
                                    tmp_o.append((rp_o, rel_o, att_o))
                            self.ordering = copy.deepcopy(tmp_o)

                        texts += cur_word
                    else:
                        tmp.append((rel, att, agg))

                # Natural concatenate
                ttmp = self.concate_by_comma_and(texts)
                if ttmp:
                    # Consider case where the label of the attribute is empty string
                    att_desc = self.description_of_rel(target_relation, ttmp, not att_flag)

                    text = self.concate_by([text, att_desc], ",")
                self.projection = tmp

            if self.grouping:
                # Begin sentence
                if not text:
                    text = SStrSen([SStrWord([target_relation])])

                tmp = []
                grouping_atts = {}
                for rp, rel, att in self.grouping:
                    if rp == target_relation:
                        grouping_atts[rel] = grouping_atts.get(rel, []) + [att]
                    else:
                        tmp.append((rp, rel, att))
                if grouping_atts:
                    grouping_flag = True
                    texts = SStrSen.create_empty_object()
                    for key_rel, att_list in grouping_atts.items():
                        # description of attributes in the att_list
                        atts_str = self.concate_by_comma_and(SStrSen([SStrWord([item]) for item in att_list]))
                        # Append to the string
                        texts += self.description_of_rel(key_rel, atts_str).combine_words()
                    text += self.concate_by_comma_and(texts).add_prefix("for each ")
                self.grouping = tmp

            if self.having:
                tmp = []
                texts = SStrSen.create_empty_object()
                for rp, rel, att, func, op, val in self.having:
                    if rp.is_same_root(target_relation):
                        having_flag = True
                        sub_words = SStrSen.create_empty_object()
                        att_sen = SStrSen([SStrWord([att])])
                        att_desc = self.description_of_rel(rel, att_sen)
                        for item in [func, att_desc, op, val]:
                            sub_words += item
                        texts += sub_words.combine_words()
                    else:
                        tmp.append((rp, rel, att, func, op, val))
                if texts:
                    text.add_suffix(",")
                    text += self.concate_by_comma_and(texts).add_prefix(f"considering only those groups whose ")
                self.having = tmp

            assert (
                grouping_flag or grouping_flag == having_flag
            ), f"HAVING must be used with GROUP BY, but {grouping_flag} != {having_flag}"

            # Get join_conditions for target relation
            if self.join_conditions:
                # Begin sentence
                if not text:
                    text = SStrSen([SStrWord([target_relation])])
                tmp = []
                texts = SStrSen.create_empty_object()
                for reference_point, rel1, edge, rel2, has_incoming_edge in self.join_conditions:
                    # Append to the string of reference point if it has no incoming edge
                    if not has_incoming_edge and reference_point == target_relation:
                        # Append if there is an edge or was an edge in the previous iteration
                        if edge or texts:
                            texts += SStrSen([SStrWord([edge, rel2])])
                            # texts += self.concate_by([edge, rel2], " ")
                            # Search for correlation condition in the selection
                            correlations_for_rel2 = [
                                sel
                                for sel in self.selection
                                if sel[0] != sel[1]
                                and sel[0] == target_relation
                                and sel[1].is_same_root(rel2)
                                and rel2 == sel[5]
                            ]
                            assert (
                                len(correlations_for_rel2) <= 1
                            ), f"the number of correlation conditions for {rel2} is {len(correlations_for_rel2)} > 1"
                            if correlations_for_rel2:
                                selected_correlation = correlations_for_rel2[0]
                                self.selection.remove(selected_correlation)
                                texts += selected_correlation[2].add_prefix("of the same ")
                                # texts[-1] += f" of the same {selected_correlation[2]}"

                    # Append to the string of rel1 if it has incoming edge
                    elif has_incoming_edge and rel1 == target_relation:
                        # Append if there is an edge or was an edge in the previous iteration
                        if edge or texts:
                            texts += SStrSen([SStrWord([edge, rel2])])
                            # texts += self.concate_by([edge, rel2], " ")
                    else:
                        tmp.append((reference_point, rel1, edge, rel2, has_incoming_edge))
                if texts:
                    join_flag = True
                    if having_flag:
                        text.add_suffix(",")
                    text += target_relation.add_prefix("in which ")
                    texts.combine_words()
                text += texts
                self.join_conditions = tmp

            # Get selection for target relation
            if self.selection:
                # Begin sentence
                if not text:
                    text = SStrSen([SStrWord([target_relation])])
                tmp = []
                texts = SStrSen.create_empty_object()
                # Handle selection for non-join relations
                for rp, rel, att, op, val, val_parent in self.selection:
                    if rp.is_same_root(target_relation):
                        # If attribute is an empty string
                        subwords = SStrSen.create_empty_object()
                        if type(val) == SStrSen:
                            val_desc = val
                        else:
                            val_desc = SStrSen([SStrWord([val])])
                        if val_parent:
                            val_desc += val_parent.add_prefix("of those ")
                        if att.is_empty_string and op.startswith("there"):
                            subwords += op
                            subwords += val_desc
                        else:
                            subwords += self.description_of_rel(rel, SStrSen([SStrWord([att])]))
                            subwords += op
                            subwords += val_desc
                        subwords.combine_words()
                        texts += subwords
                    else:
                        tmp.append((rp, rel, att, op, val, val_parent))
                if texts:
                    pass  # where clause not generated this step
                self.selection = tmp

        dnf_idx = 0
        dnf_cnt_with_texts = 0
        while dnf_idx < len(self.selection_dnf):
            target_clause = self.selection_dnf[dnf_idx]

            # Begin sentence
            if not text:
                text = SStrSen([SStrWord([target_relation])])
            tmp = []
            texts = SStrSen.create_empty_object()
            # Handle selection for non-join relations
            for rp, rel, att, op, val, val_parent in target_clause:
                # If attribute is an empty string
                subwords = SStrSen.create_empty_object()
                if type(val) == SStrSen:
                    val_desc = val
                else:
                    val_desc = SStrSen([SStrWord([val])])
                if val_parent:
                    val_desc += val_parent.add_prefix("of those ")
                if att.is_empty_string and op.startswith("there"):
                    subwords += op
                    subwords += val_desc
                else:
                    subwords += self.description_of_rel(rel, SStrSen([SStrWord([att])]))
                    subwords += op
                    subwords += val_desc
                subwords.combine_words()
                texts += subwords
            if texts:
                if dnf_cnt_with_texts != 0:
                    texts.add_prefix("), or where ( ")
                else:
                    texts.add_prefix("where ( ")

                if dnf_idx == len(self.selection_dnf) - 1:
                    texts.add_suffix(" )")
                text += self.concate_by_comma_and(texts)
                dnf_cnt_with_texts += 1
            dnf_idx += 1

        if self.sentences:
            text = self.concate_by([text] + self.sentences, ", and ")
        if self.limit:
            limit_text = SStrSen.create_empty_object()
            limit_text = limit_text.add_suffix("Find only " + str(self.limit) + " results")
            text = self.concate_by([text] + [limit_text], ". ")
        return text

    # Converting to text
    def projection_to_text(self) -> str:
        pass

    def selection_to_text(self) -> str:
        pass

    def grouping_to_text(self) -> str:
        pass

    def having_to_text(self) -> str:
        pass

    def ordering_to_text(self) -> str:
        pass

    def add_limit(self, limit_num):
        self.limit = limit_num

    # Add sub-graphs
    def add_projection(self, relation: Node, attribute: Node, agg_func: Optional[str]) -> None:
        # Create SStr objects
        rel_sstr = SStrChar(
            relation.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Projection, is_table=True
        )
        att_sstr = SStrChar(
            attribute.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Projection
        )
        agg_sstr = (
            SStrChar(agg_func, relation.entity_name, attribute.entity_name, op_type=OperationType.Projection)
            if agg_func
            else None
        )
        self.projection.append((rel_sstr, att_sstr, agg_sstr))

    def add_selection(
        self,
        reference_point: Node,
        relation: Node,
        attribute: Node,
        op: Predicate,
        operand: str,
        operand_parent: Optional[Node] = None,
    ) -> None:
        # Create SStr objects
        ref_sstr = SStrChar(
            reference_point.label,
            reference_point.entity_name,
            attribute.entity_name,
            op_type=OperationType.Selection,
            is_table=True,
        )
        rel_sstr = SStrChar(
            relation.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection, is_table=True
        )
        att_sstr = SStrChar(
            attribute.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection
        )
        op_sstr = SStrChar(op.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection)
        # Handle different by operand type
        arg2 = operand_parent.entity_name if operand_parent else relation.entity_name
        if type(operand) == SStrSen:
            operand_sstr = operand
            operand_parent_sstr = None
        else:
            if type(operand) == str:
                arg1 = operand
                arg3 = attribute.entity_name
            else:
                arg1 = operand.label
                arg3 = operand.entity_name
            operand_sstr = SStrChar(arg1, arg2, arg3, op_type=OperationType.Selection)
            operand_parent_sstr = (
                SStrChar(
                    operand_parent.label,
                    operand_parent.entity_name,
                    arg3,
                    op_type=OperationType.Selection,
                    is_table=True,
                )
                if operand_parent
                else None
            )
        if len(self.selection_dnf) <= op.dnf_idx:
            self.selection_dnf.extend([[] for _ in range(op.dnf_idx - len(self.selection_dnf) + 1)])
        self.selection_dnf[op.dnf_idx].append(
            (ref_sstr, rel_sstr, att_sstr, op_sstr, operand_sstr, operand_parent_sstr)
        )
        self.selection.append((ref_sstr, rel_sstr, att_sstr, op_sstr, operand_sstr, operand_parent_sstr))

    def add_join_conditions(
        self, reference_point: Node, relation1: Node, edge: str, relation2: Node, has_incoming_edge: bool
    ) -> None:
        # Create SStr objects
        ref_sstr = SStrChar(
            reference_point.label, reference_point.entity_name, op_type=OperationType.Selection, is_table=True
        )
        rel1_sstr = SStrChar(relation1.label, relation1.entity_name, op_type=OperationType.Selection, is_table=True)
        edge_sstr = SStrChar(edge, relation1.entity_name, relation2.entity_name, op_type=OperationType.Selection)
        rel2_sstr = SStrChar(relation2.label, relation2.entity_name, op_type=OperationType.Selection, is_table=True)
        self.join_conditions.append((ref_sstr, rel1_sstr, edge_sstr, rel2_sstr, has_incoming_edge))

    def add_grouping(self, reference_point: Node, relation: Node, attribute: Node) -> None:
        # Create SStr objects
        ref_sstr = SStrChar(
            reference_point.label,
            reference_point.entity_name,
            attribute.entity_name,
            op_type=OperationType.Grouping,
            is_table=True,
        )
        rel_sstr = SStrChar(
            relation.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Grouping, is_table=True
        )
        att_sstr = SStrChar(
            attribute.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Grouping
        )
        self.grouping.append((ref_sstr, rel_sstr, att_sstr))

    def add_having(
        self, reference_point: Node, relation: Node, attribute: Node, function: Node, edge: Predicate, value: Node
    ) -> None:
        # Create SStr objects
        ref_sstr = SStrChar(
            reference_point.label,
            reference_point.entity_name,
            attribute.entity_name,
            op_type=OperationType.Selection,
            is_table=True,
        )
        rel_sstr = SStrChar(
            relation.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection, is_table=True
        )
        att_sstr = SStrChar(
            attribute.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection
        )
        func_sstr = SStrChar(
            function.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection
        )
        edge_sstr = SStrChar(edge.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection)
        val_sstr = SStrChar(value.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Selection)

        self.having.append((ref_sstr, rel_sstr, att_sstr, func_sstr, edge_sstr, val_sstr))

    def add_ordering(self, reference_point: Node, relation: Node, attribute: Node) -> None:
        ref_sstr = SStrChar(
            reference_point.label,
            reference_point.entity_name,
            attribute.entity_name,
            op_type=OperationType.Grouping,
            is_table=True,
        )
        rel_sstr = SStrChar(
            relation.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Ordering, is_table=True
        )
        att_sstr = SStrChar(
            attribute.label, relation.entity_name, attribute.entity_name, op_type=OperationType.Ordering
        )
        self.ordering.append((ref_sstr, rel_sstr, att_sstr))

    # others
    def set_nested(self, phrase: str) -> None:
        pass

    def add_sentence(self, sentence: str) -> str:
        self.sentences.append(sentence)

    def add(self, string_builder) -> None:
        self.projection.extend(string_builder.projection)
        self.selection.extend(string_builder.selection)
        for dnf_idx, dnf_clauses in enumerate(string_builder.selection_dnf):
            if len(dnf_clauses) > 0:
                if dnf_idx >= len(self.selection_dnf):
                    self.selection_dnf.extend([[] for _ in range(dnf_idx - len(self.selection_dnf) + 1)])
                self.selection_dnf[dnf_idx].extend(dnf_clauses)
        self.join_conditions.extend(string_builder.join_conditions)
        self.grouping.extend(string_builder.grouping)
        self.having.extend(string_builder.having)
        self.ordering.extend(string_builder.ordering)
        return self
