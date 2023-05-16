from typing import Any, Dict, Tuple

from src.pylogos.algorithm.MRP import MRP
from src.pylogos.query_graph.koutrika_query_graph import Query_graph
from src.sql_generator.sql_gen_utils.utils import load_graphs, load_objs


def translate(query_graph: Query_graph) -> Tuple[str, Dict[str, Any]]:
    return MRP()(query_graph.query_subjects[0], None, None, query_graph)


if __name__ == "__main__":
    filepath = "/home/hjkim/PRODA/non-nested/result2.out"
    graphs = load_graphs(filepath + ".graph", 13)
    objs = load_objs(filepath + ".obj", 13)
    # for obj, (tree, graph) in zip(objs, graphs):
    for obj, graph in zip(objs, graphs):
        print(obj["sql"])
        text, _ = translate(graph[1])
    print(text)
