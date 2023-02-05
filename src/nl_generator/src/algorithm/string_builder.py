from typing import List, Tuple, Optional

from src.query_graph.koutrika_query_graph import Query_graph


class StringBuilder():
    def __init__(self, is_nested=False):
        self.is_nested: bool = is_nested
        self.projection: List[Tuple(str,str, str)] = []
        self.selection: List[Tuple(str, str, str, str, str, str)] = []
        self.grouping: List[str] = []
        self.having: List[Tuple[str, str, str, str, str, str]] = []
        self.ordering: List[str] = []
        self.sentences: List[str] = []
        self.join_conditions: List[Tuple(str, str, str, str, bool)] = []

    def description_of_rel(self, rel: str, desc: str, dont_use_of: bool = False):
        if rel:
            if desc == " " or "":
                return f"{rel}"
            elif dont_use_of:
                return f"{desc} {rel}"
            else:
                return f"{desc} of {rel}"
        else:
            return f"{desc}"

    def concate_by(self, texts: List[str], sep_str: str):
        constructed_text = ""
        for i, t in enumerate(texts):
            if type(t) == str and t not in ["", " "]:
                if constructed_text:
                    constructed_text += f"{sep_str}{t}"
                else:
                    constructed_text += f"{t}"
        return constructed_text

    def concate_by_comma_and(self, texts: List[str]):
        constructed_text = ""
        is_more_than_two_items = len(texts) > 2
        for i, t in enumerate(texts):
            if i == 0:
                constructed_text += f"{t}"
            elif i == len(texts) - 1:
                constructed_text += f", and {t}" if is_more_than_two_items else f" and {t}"
            else:
                constructed_text += f", {t}"
        return constructed_text

    def to_text(self):
        text = ""
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
                texts = []
                att_flag = False
                for rel, att, agg in self.projection:
                    if rel == target_relation:
                        # Meta information
                        if att not in ["", " "]:
                            att_flag = True
                        # To string
                        if agg:
                            texts.append(self.concate_by([agg, att], " "))
                        else:
                            texts.append(f"{att}")
                    else:
                        tmp.append((rel, att, agg))

                # Natural concatenate
                ttmp = self.concate_by_comma_and(texts)
                if ttmp:
                    # Consider case where the label of the attribute is empty string
                    att_desc = self.description_of_rel(target_relation, ttmp, not att_flag)
                    
                    text = self.concate_by([text, att_desc], ", ")
                self.projection = tmp

            if self.grouping:
                # Begin sentence
                if not text:
                    text = f"{target_relation}"

                tmp = []
                grouping_atts = {}
                for rp, rel, att in self.grouping:
                    if rp == target_relation:
                        grouping_atts[rel] = grouping_atts.get(rel, []) + [att]
                    else:
                        tmp.append((rp, rel, att))
                if grouping_atts:
                    grouping_flag = True
                    texts = []
                    for key_rel, att_list in grouping_atts.items():
                        # description of attributes in the att_list
                        atts_str = self.concate_by_comma_and(att_list)
                        # Append to the string
                        texts.append(self.description_of_rel(key_rel, atts_str))
                    text += f" for each {self.concate_by_comma_and(texts)}"
                self.grouping = tmp
            
            if self.having:
                tmp = []
                texts = []
                for rp, rel, att, func, op, val in self.having:
                    if rp == target_relation:
                        having_flag = True
                        att_desc = self.description_of_rel(rel, att)
                        texts.append(f"{func} {att_desc} {op} {val}")
                    else:
                        tmp.append((rp, rel, att, func, op, val))
                if texts:
                    text += f", considering only those groups whose {self.concate_by_comma_and(texts)}"
                self.having = tmp
            
            assert grouping_flag or grouping_flag == having_flag, f"HAVING must be used with GROUP BY, but {grouping_flag} != {having_flag}"

            # Get join_conditions for target relation
            if self.join_conditions:
                # Begin sentence
                if not text:
                    text = f"{target_relation}"
                tmp = []
                texts = []
                for reference_point, rel1, edge, rel2, has_incoming_edge in self.join_conditions:
                    # Append to the string of reference point if it has no incoming edge
                    if not has_incoming_edge and reference_point == target_relation:
                        # Append if there is an edge or was an edge in the previous iteration
                        if edge or texts:
                            texts.append(self.concate_by([edge, rel2], " "))
                            # Search for correlation condition in the selection
                            correlations_for_rel2 = [sel for sel in self.selection if sel[0] != sel[1] and sel[0] == target_relation and sel[1] == rel2 and sel[1] == sel[5]]
                            assert len(correlations_for_rel2) <= 1, f"the number of correlation conditions for {rel2} is {len(correlations_for_rel2)} > 1"
                            if correlations_for_rel2:
                                selected_correlation = correlations_for_rel2[0]
                                self.selection.remove(selected_correlation)
                                texts[-1] += f" of the same {selected_correlation[2]}"
                            
                    # Append to the string of rel1 if it has incoming edge
                    elif has_incoming_edge and rel1 == target_relation:
                        # Append if there is an edge or was an edge in the previous iteration
                        if edge or texts:
                            texts.append(self.concate_by([edge, rel2], " "))
                    else:
                        tmp.append((reference_point, rel1, edge, rel2, has_incoming_edge))
                if texts:
                    join_flag = True
                    if having_flag:
                        text += ', '
                    text += f" in which {target_relation} "
                text += " ".join(texts)
                self.join_conditions = tmp

            # Get selection for target relation
            if self.selection:
                # Begin sentence
                if not text:
                    text = f"{target_relation}"       

                tmp = []
                texts = []
                # Handle selection for non-join relations
                for rp, rel, att, op, val, val_parent in self.selection:
                    if rp == target_relation:
                        # If attribute is an empty string
                        val_desc = f"{val} of those {val_parent}" if val_parent else val
                        if att == " " and op.startswith("there"):
                            texts.append(f"{op} {val_desc}")
                        else:
                            texts.append(f"{self.description_of_rel(rel, att)} {op} {val_desc}")
                    else:
                        tmp.append((rp, rel, att, op, val, val_parent))
                if texts:
                    if join_flag:
                        text += " and "
                    else:
                        if having_flag and text[-1] != ",":
                            text += ","
                        text += " where "
                    text += " and ".join(texts)
                self.selection = tmp
        if self.sentences:
            text = self.concate_by([text] + self.sentences, ", and ")
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

    # Add sub-graphs
    def add_projection(self, relation: str, attribute: str, agg_func: str) -> None:
        self.projection.append((relation, attribute, agg_func))
    
    def add_selection(self, reference_point: str, relation: str, attribute: str, op: str, operand: str, operand_parent: Optional[str] = None) -> None:
        self.selection.append((reference_point, relation, attribute, op, operand, operand_parent))

    def add_join_conditions(self, reference_point: str, relation1: str, edge: str, relation2: str, has_incoming_edge: bool) -> None:
        self.join_conditions.append((reference_point, relation1, edge, relation2, has_incoming_edge))

    def add_grouping(self, reference_point: str, relation: str, attribute: str) -> None:
        self.grouping.append((reference_point, relation, attribute))
    
    def add_having(self, reference_point: str, relation: str, attribute: str, function: str, edge: str, value: str) -> None:
        self.having.append((reference_point, relation, attribute, function, edge, value))
        pass
    
    def add_ordering(self, phrase: str) -> None:
        pass

    # others
    def set_nested(self, phrase: str) -> None:
        pass

    def add_sentence(self, sentence: str) -> str:
        self.sentences.append(sentence)

    def add(self, string_builder) -> None:
        self.projection.extend(string_builder.projection)
        self.selection.extend(string_builder.selection)
        self.join_conditions.extend(string_builder.join_conditions)
        self.grouping.extend(string_builder.grouping)
        self.having.extend(string_builder.having)
        return self