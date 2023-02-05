from query_graph import Relation as R, Attribute as A, Value as V, Function as F
from query_graph import Projection as Proj, Selection as Sel, Operation as Op, Aggregation as Agg, Ordering as Ord, Grouping as Group, Having as Hav, Limit, Join

# from SQL2Text.query_graph.queryGraph import Relation as R, Attribute as A, Value as V, Function as F
# from SQL2Text.query_graph.queryGraph import Projection as Proj, Selection as Sel, Operation as Op, Aggregation as Agg, Ordering as Ord, Grouping as Group, Having as Hav, Limit


generic_templates = [
    {
        "path": [R, Proj, A],
        "nl": ["l(A1)", "of", "l(R1)"]
    },
    {
        "path": [R, Sel, A],
        "nl": ["l(R1)", "VAL_SEL", "l(A1)"]
    },
    {
        "path": [R, Sel, A, Op, A, Proj, R],
        "nl": ["l(R1)", "whose", "l(A1)", "is", "l(Op1)", "l(A1)", "of", "l(R2)"]
    },
    {
        "path": [R, Proj, A, Agg, F],
        "nl": ["l(F1)", "l(R1)", "'s", "l(A1)"]
    },
    {
        "path": [R, Sel, A, Op, V],
        "nl": ["l(R1)", "whose", "l(A1)", "is", "l(Op1)", "l(V1)"]
    },
    {
        "path": [R, Ord, A],
        "nl": ["l(A1)", "of", "l(R1)", "in", "l(Ord1)", "order"]
    },
    {
        "path": [R, Group, A],
        "nl": ["l(A1)", "of", "l(R1)"]
    },
    {
        "path": [R, Hav, A, Agg, F, Op, V],
        "nl": ["l(F1)", "l(R1)", "l(A1)", "l(Op1)", "l(V1)"]
    },
    {
        "path": [R, Limit, V],
        "nl": ["top", "l(V1)"]
    },
    {
        "path": [R, Sel, A, Op, F, Agg, A, Proj, R],
        "nl": ["l(R1)", "whose", "l(F1)", "l(A1)", "is", "l(Op1)", "the", "l(A2)", "of", "l(R2)"]
    },
    {
        "path": [R, Sel, A, Op, A, Sel, R],
        "nl": ["l(R1)", "whose", "l(A1)", "l(Op1)", "l(A2)", "of", "l(R2)"]
    },
    {
        "path": [R, Join, A, Op, A, Join, R],
        'nl': ["l(R1)", "l(A1)", "l(Op1)", "l(R2)", "l(A2)"]
    }
]
