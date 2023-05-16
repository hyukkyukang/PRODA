from src.pylogos.query_graph.koutrika_query_graph import Value, Selection, Membership

VAL_SEL = " whose "
CONJ_SEL = " and "
COORD_CONJ = " and "
CONJ_NOUN = " that "
CONJ_PROJ = ", "

def label(item):
    return item.label
    # if issubclass(type(item), Node):
    #     return item.label
    # else:
    #     if type(item) == Membership:
    #         return "of"
    #     elif type(item) == Selection:
    #         return " of "
    #     elif type(item) == Predicate:
    #         return " is "
    #     return type(item).__name__

def modify_label(item, value):
    item.label += value


class BST():
    """
    Binary Search Tree Algorithm
        Input:
            - v: node (query subject)
            - g: graph (query graph)
            - open: list ()
            - close: list ()
            - pStr: str (membership clauses)
            - fStr: str (join clauses)
            - wStr: str (where clauses)
        Output: pStr, fStr, wStr
    """
    def __init__(self):
        self.do_resolve_common_expressions = True

    def __call__(self, *args, **kwargs):
        # self, args = args[0], args[1:]
        pStr, fStr, wStr = self._call(*args, **kwargs)
        return f"Find {pStr} for{fStr}. Return results only for {wStr}.".replace("  ", " ")

    def _call(self, v, g, open=[], close=[], pStr="", fStr="", wStr=""):
        print(f"\tBST Called with v:{v.name} ({type(v).__name__})")
        sel_edges = 0
        children = []
        close.append(v)

        # Add description for join conditions
        if (v not in g.secondary_relations): fStr += f" {label(v)}"

        # Add description for groupby clause
        
        # Add description for projection 
        
        # Add description for selection

        # Check two-hop nodes and add description for from and where conditions
        for src, edge, dst in g.get_one_hop_path_of(v):
            for next_src, next_edge, next_dst in g.get_one_hop_path_of(dst):
                if src == next_dst: continue # Missing in the algorithm of the paper
                if type(next_dst) == Value:
                    str = label(v) + VAL_SEL + label(dst) + ' ' + label(next_edge) + ' ' + label(next_dst) + ' '
                    wStr = self._make_lbl(wStr, str, CONJ_SEL)
                elif dst not in close:
                    if dst not in children:
                        if type(edge) == Selection:
                            sel_edges += 1
                        children.append(dst)
                        fStr = f" {fStr} that {label(edge)}"

        # Modify labels for recursion
        while children:
            tv = children.pop()
            # sel_edges -= 1
            # if (sel_edges > 0):
            #     modify_label(tv, COORD_CONJ)
            # elif (sel_edges == 0):
            #     modify_label(tv, CONJ_NOUN)
            open.append(tv)

        # Add description for projection
        for src, dst in g.in_edges(v):
            edge = g.edges[src, dst]['data']
            if type(edge) == Membership:
                children.append((label(src), label(edge)))
        tmp_str = ''
        if children and self.do_resolve_common_expressions:
            # My modification of the algorithm to apply resolve_common_expressions written in the paper
            tmp_str = self._resolve_common_expressions(children, label(v))
            print(f"{v.name}: {tmp_str}")
        else:
            while children:
                x, y = children.pop()
                tmp_str += " the " + x + " " + y + " " + label(v)
                if len(children) != 1:
                    tmp_str += ", "
        if tmp_str:
            pStr = self._make_lbl(pStr, tmp_str, CONJ_PROJ)

        # Recursive call
        if open:
            v = open.pop()
            pStr, fStr, wStr = self._call(v, g, open, close, pStr, fStr, wStr)

        return pStr, fStr, wStr

    def _make_lbl(self, clause, label, conj):
        if clause:
            if ", and" in clause:
                c_split = clause.split(', and')
                assert len(c_split) == 2
                clause = clause.replace(", and", ", ")
                return clause + f",{conj}" + label
            elif " and " in clause:
                c_split = clause.split(' and')
                assert len(c_split) == 2
                clause = clause.replace(" and", ", ")
                return clause + f",{conj}" + label
            else:
                return clause + conj + label
        else:
            return label

    def _resolve_common_expressions(self, expressions, relation_desc):
        """Detailed algorithm is not written in the paper.
            This is my own implementation based on the short description in the paper
        """
        tmp = "the "
        for idx in range(len(expressions)):
            subject, preposition = expressions[idx]
            if idx+1 == len(expressions):
                tmp += f"{subject} "
            elif idx+2 == len(expressions):
                tmp += f"{subject} and "
            else:
                tmp += f"{subject}, "
        tmp += f"of {relation_desc}"
        return tmp


if __name__ == "__main__":
    pass
