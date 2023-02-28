import classNames from "classnames";
import React, { useEffect, useMemo, useState, useContext } from "react";
import { AiOutlineMinusSquare, AiOutlinePlusSquare } from "react-icons/ai";
import { CellBase, ColumnIndicatorComponent, DataViewerComponent, Matrix, Point, Spreadsheet } from "react-spreadsheet-custom";

import { useQuery } from "react-query";
import { runEVQL, runSQL } from "../../api/connect";
import { isEmptyObject } from "../../utils";
import { PGResultToTableExcerpt } from "../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../TableExcerpt/TableExcerpt";
import { aggFunctions, Clause, EVQLNode, EVQLTree, Function } from "./EVQL";
import { addEVQLNode, EVQLNodeToEVQLTable, getNode, getProjectedNames, getSubtree, getTreeTraversingPaths, parseExpressions } from "./utils";
import { CoordinateContext } from "../Collection/querySheet";

const demoDBName = process.env.NEXT_PUBLIC_DemoDBName;

// This is from react-spreadsheet-custom/src/selection.ts
export enum EntireType {
    Row = "row",
    Column = "column",
    Table = "table",
}

export interface Coordinate {
    tableIndices: number[];
    colIdx: number;
    rowIdx: number;
}

export interface IEVQLTableHeader {
    name: string;
    aggFuncs: number[];
    isToProject: boolean;
}

export interface IEVQLTable {
    headers: IEVQLTableHeader[];
    rows: Matrix<CellBase<React.ReactElement>>;
}

export interface IEVQLVisualizationContext {
    evqlRoot: EVQLTree;
    setEVQLRoot?: React.Dispatch<React.SetStateAction<EVQLTree>>;
    setSelectedCoordinate?: React.Dispatch<React.SetStateAction<Coordinate | undefined>>;
    childListPath: number[];
    editable: boolean;
    isFirstNode: boolean | undefined;
}

export interface EVQLTreeWrapperProps {
    evqlRoot: EVQLTree;
    setEVQLRoot?: React.Dispatch<React.SetStateAction<EVQLTree>>;
    setSelectedCoordinate?: React.Dispatch<React.SetStateAction<Coordinate | undefined>>;
    editable?: boolean;
}

export const EVQLColumnIndicator: ColumnIndicatorComponent = ({ column, label, selected, onSelect }) => {
    // column is the id
    const handleClick = React.useCallback(
        (event: React.MouseEvent) => {
            onSelect(column, event.shiftKey);
        },
        [onSelect, column]
    );
    const evqlTableHeader = label as unknown as IEVQLTableHeader;

    // If isToProject,
    var headerStyle = {};
    var componentToDisplay: React.ReactElement = isEmptyObject(evqlTableHeader) ? <>{String(column)}</> : <>{evqlTableHeader.name}</>;
    if (!isEmptyObject(evqlTableHeader) && evqlTableHeader.isToProject) {
        // Highlight the header background
        headerStyle = { background: "#FFDDA7", color: "black" };
        // Get all aggregation functions applied to this column
        const aggFuncs = evqlTableHeader.aggFuncs.map((aggFuncId) => aggFunctions[aggFuncId]);
        componentToDisplay = (
            <>
                <>{evqlTableHeader.name}</>
                <br />
                {aggFuncs.join(", ") == "none" ? <></> : <div style={{ fontSize: "14px" }}>{"(" + aggFuncs.join(", ") + ")"}</div>}
            </>
        );
    }

    return (
        <th
            className={classNames("Spreadsheet__header", {
                "Spreadsheet__header--selected": selected,
            })}
            onClick={handleClick}
            tabIndex={0}
            style={headerStyle}
        >
            {componentToDisplay}
        </th>
    );
};

export const EVQLTable = (props: IEVQLVisualizationContext) => {
    const { evqlRoot, setEVQLRoot, setSelectedCoordinate, childListPath, editable, isFirstNode } = props;

    // Local context to visualize table
    const [evqlNode, setEVQLNode] = useState({} as EVQLNode);
    const [rowLabels, setRowLabels] = useState<string[]>(["1"]);
    const [tableContext, setTableContext] = useState<IEVQLTable>({} as IEVQLTable);

    const [subTree_str, setSubTree_str] = useState("");
    const { isLoading, isError, data, error } = useQuery(
        ["runEVQL", subTree_str, "proda_demo"],
        () => runEVQL({ evqlStr: subTree_str, dbName: "proda_demo" }),
        { enabled: !!subTree_str }
    );
    const resultTable = useMemo<ITableExcerpt>(() => PGResultToTableExcerpt(data?.result), [data]);

    // To get selected cell information
    const { selectedCoordinate, SetSelectedCoordinate } = useContext(CoordinateContext);

    const dataViewer: DataViewerComponent<CellBase<any>> = (cellData) => {
        if (cellData.cell) {
            const value = cellData.cell.value;
            return <>{value}</>;
        }
        return <></>;
    };

    const onChangeHandler = (newRows: Matrix<CellBase<any>>): void => {
        // Create new EVQLNode
        evqlNode.predicate.clauses = [];
        for (let i = 0; i < newRows.length; i++) {
            const newClause: Clause = { conditions: [] };
            for (let j = 0; j < newRows[i].length; j++) {
                const tmp = newRows[i][j];
                if (tmp && tmp.value != null) {
                    try {
                        // Create a condition
                        const conditions: Function[] = parseExpressions(tmp.value, evqlNode.headers);
                        if (!isEmptyObject(conditions)) newClause.conditions.push(...conditions);
                    } catch {
                        console.warn(`Not a complete expression yet: ${tmp.value}`);
                    }
                }
            }
            if (newClause) evqlNode.predicate.clauses.push(newClause);
        }
    };

    const onSelectHandler = (points: Point[], selection: any) => {
        const isPointRange = (selection: any) => {
            return isRange(selection?.start) && isRange(selection?.end);
        };
        const isRange = (selection: any) => {
            return (
                // @ts-ignore
                typeof selection?.row === "number" &&
                // @ts-ignore
                typeof selection?.column === "number"
            );
        };

        const isEntireTable = (selection: any) => {
            return selection !== null && "type" in selection && selection.type === EntireType.Table;
        };

        const isEntireColumns = (selection: any) => {
            return selection !== null && "type" in selection && selection.type === EntireType.Column;
        };

        const isEntireRows = (selection: any) => {
            return selection !== null && "type" in selection && selection.type === EntireType.Row;
        };
        var newCoordinate = { tableIndices: [], rowIdx: -1, colIdx: -1 };
        if (isPointRange(selection)) {
            newCoordinate["rowIdx"] = points[0].row;
            newCoordinate["colIdx"] = points[0].column;
        } else if (isEntireTable(selection)) {
        } else if (isEntireColumns(selection)) {
            newCoordinate["colIdx"] = points[0].column;
        } else if (isEntireRows(selection)) {
            newCoordinate["rowIdx"] = points[0].row;
        } else {
            return;
        }
        if (editable && setSelectedCoordinate) setSelectedCoordinate(newCoordinate);
    };

    const onClickHandler = (points: Point[], selection: any) => {
        if (points.length == 1) {
            var newCoordinate = { x: -1, y: -1 };
            // Figure out if header is selected or not
            // If selection object has a property "type", header is selected
            if (selection.hasOwnProperty("type")) {
                newCoordinate.x = points[0].row;
                newCoordinate.y = points[0].column;
            } else {
                newCoordinate.x = points[0].row + 1;
                newCoordinate.y = points[0].column;
            }
            SetSelectedCoordinate(newCoordinate);
        }
    };

    const addRowHandler: React.MouseEventHandler = () => {
        if (editable && setEVQLRoot) {
            evqlNode.predicate.clauses.push({ conditions: [] });
            setEVQLRoot(Object.assign({}, evqlRoot));
        }
    };

    const removeRowHandler: React.MouseEventHandler = (event) => {
        const idx: number = parseInt(event?.currentTarget?.id);
        if (editable && setEVQLRoot) {
            evqlNode.predicate.clauses.splice(idx, 1);
            setEVQLRoot(Object.assign({}, evqlRoot));
        }
    };

    useEffect(() => {
        if (evqlRoot) {
            const node = getNode(evqlRoot, [...childListPath]);
            const tmpTableContext = EVQLNodeToEVQLTable(node, editable);
            const tmpRowLabels = Array.from({ length: tmpTableContext.rows.length }, (x, i) => i + 1).map((x) => x.toString());
            // Get table excerpt
            if (isEmptyObject(node.table_excerpt)) {
                // Get from prev node
                if (!isFirstNode) {
                    const prevSubtree = getSubtree(evqlRoot, [...childListPath]);
                    const prevSubtree_str = JSON.stringify(prevSubtree);
                    if (prevSubtree_str) {
                        throw new Error("Not implemented. Need to check if using useQuery is OK.");
                        const { isLoading, isError, data, error } = useQuery(["runEVQL", prevSubtree_str, "proda_demo"], () =>
                            runEVQL({ evqlStr: prevSubtree_str, dbName: "proda_demo" })
                        );
                        node.table_excerpt = PGResultToTableExcerpt(data["result"]);
                    }
                } else {
                    // Get default table
                    runSQL({ sql: `SELECT * FROM cars`, dbName: demoDBName })
                        .then((result) => {
                            node.table_excerpt = PGResultToTableExcerpt(result);
                        })
                        .catch((err) => {
                            console.warn(`error:${err}`);
                        });
                }
            }
            if (!editable) {
                // Get and show result table
                const subtree = getSubtree(evqlRoot, [...childListPath]);
                setSubTree_str(JSON.stringify(subtree));
            }
            setEVQLNode(node);
            setTableContext(tmpTableContext);
            setRowLabels(tmpRowLabels);
        }
    }, []);

    if (!isEmptyObject(tableContext)) {
        return (
            <div style={{ overflow: "scroll" }}>
                {evqlNode.table_excerpt ? <b>Table:</b> : null}
                {evqlNode.table_excerpt ? <TableExcerpt queryResult={evqlNode.table_excerpt} /> : null}
                <b>EVQL:</b>
                <br />
                <div style={{ display: "inline-block" }}>
                    <Spreadsheet
                        className="table_sketch"
                        data={tableContext.rows}
                        columnLabels={tableContext.headers}
                        rowLabels={rowLabels}
                        onChange={editable ? onChangeHandler : undefined}
                        onKeyDown={
                            editable
                                ? (event) => {
                                      if (event.key == "Enter" && setEVQLRoot) setEVQLRoot(Object.assign({}, evqlRoot));
                                  }
                                : undefined
                        }
                        onSelect={editable ? onSelectHandler : onClickHandler}
                        ColumnIndicator={EVQLColumnIndicator}
                        DataViewer={(e) => dataViewer(e)}
                    />
                    <div style={{ display: "inline-block" }}>
                        {evqlNode?.predicate?.clauses.map((clause, idx) => (
                            <div key={idx}>
                                {evqlNode?.predicate?.clauses.length > 1 && editable ? (
                                    <AiOutlineMinusSquare size={27} id={String(idx)} onClick={removeRowHandler} />
                                ) : null}
                                {idx == evqlNode?.predicate?.clauses.length - 1 && editable ? <AiOutlinePlusSquare size={27} onClick={addRowHandler} /> : null}
                                <br />
                            </div>
                        ))}
                    </div>
                </div>
                <br />
                <br />
                {resultTable ? <b>Result Table:</b> : null}
                {resultTable ? <TableExcerpt queryResult={resultTable} /> : null}
            </div>
        );
    }
    return <></>;
};

export const EVQLTables = (props: EVQLTreeWrapperProps) => {
    const { evqlRoot, setEVQLRoot = undefined, setSelectedCoordinate = undefined, editable = true } = props;
    // const childPathLists = isEmptyObject(evqlRoot) ? [] : getTreeTraversingPaths(evqlRoot);
    const childPathLists = getTreeTraversingPaths(evqlRoot);

    // Add & remove buttons
    const addTableHandler: React.MouseEventHandler = () => {
        // Check projection exists in the most outer node
        if (evqlRoot.node.projection.headers.length === 0) {
            alert("Please add projection first");
            return;
        }
        // Get names of projection to add to header of new node
        const newlyprojectNames = getProjectedNames(evqlRoot, []);
        // Create new node
        const newTree = addEVQLNode(evqlRoot, [...evqlRoot.node.headers].concat(newlyprojectNames));
        if (setEVQLRoot) setEVQLRoot(newTree);
    };

    const removeTableHandler: React.MouseEventHandler = (event) => {
        if (!evqlRoot.children) {
            alert("Cannot remove the last table");
            return;
        }
        // Check if any predicates or projections. If so, ask for confirmation
        if (
            evqlRoot.node.projection.headers.length > 0 ||
            (evqlRoot.node.predicate.clauses.length > 0 && evqlRoot.node.predicate.clauses[0].conditions.length > 0)
        ) {
            if (!window.confirm("Are you sure you want to delete this table?")) {
                return;
            }
        }

        // TODO: need to change data structure of EVQL.
        const subTree = evqlRoot.children[0];
        if (setEVQLRoot) setEVQLRoot(subTree);
    };

    return (
        <React.Fragment>
            {isEmptyObject(evqlRoot)
                ? null
                : childPathLists.map((path: number[], index: number) => (
                      <div key={index}>
                          {/* <Typography>Step: {index + 1}</Typography> */}
                          {childPathLists.length > 1 ? `Step: ${index + 1}` : null}
                          {editable && index + 1 == childPathLists.length ? (
                              <div style={{ display: "inline-block" }}>
                                  <button onClick={addTableHandler}>Add table</button>
                                  {index === 0 ? null : (
                                      <button onClick={removeTableHandler} style={{ marginLeft: "2px" }}>
                                          Remove table
                                      </button>
                                  )}
                              </div>
                          ) : null}
                          <br />
                          <EVQLTable
                              evqlRoot={evqlRoot}
                              setEVQLRoot={setEVQLRoot}
                              setSelectedCoordinate={setSelectedCoordinate}
                              childListPath={path}
                              editable={editable && index + 1 == childPathLists.length}
                              isFirstNode={Boolean(index > 0) ? Boolean(childPathLists[index - 1]) : undefined}
                          />
                          <br />
                          <br />
                      </div>
                  ))}
        </React.Fragment>
    );
};

export default EVQLTable;
