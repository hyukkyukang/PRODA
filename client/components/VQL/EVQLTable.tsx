import classNames from "classnames";
import React, { useEffect, useState, useRef } from "react";
import {
    Spreadsheet,
    DataViewerComponent,
    Matrix,
    CellBase,
    ColumnIndicatorComponent,
    Point,
} from "react-spreadsheet-custom";
import { AiOutlinePlusSquare, AiOutlineMinusSquare } from "react-icons/ai";

import { EVQLTree, EVQLNode, aggFunctions, Function, Clause } from "./EVQL";
import {
    getNode,
    EVQLNodeToEVQLTable,
    getTreeTraversingPaths,
    parseExpressions,
    getProjectedNames,
    addEVQLNode,
} from "./utils";
import { isEmptyObject } from "../../utils";

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
    setEVQLRoot: React.Dispatch<React.SetStateAction<EVQLTree>>;
    setSelectedCoordinate?: React.Dispatch<
        React.SetStateAction<Coordinate | undefined>
    >;
    childListPath: number[];
    editable: boolean;
}

export interface EVQLTreeWrapperProps {
    evqlRoot: EVQLTree;
    setEVQLRoot: React.Dispatch<React.SetStateAction<EVQLTree>>;
    setSelectedCoordinate?: React.Dispatch<
        React.SetStateAction<Coordinate | undefined>
    >;
    editable?: boolean;
}

export const EVQLColumnIndicator: ColumnIndicatorComponent = ({
    column,
    label,
    selected,
    onSelect,
}) => {
    // column is the id
    const handleClick = React.useCallback(
        (event: React.MouseEvent) => {
            onSelect(column, event.shiftKey);
        },
        [onSelect, column]
    );
    const evqlTableHeader = label as IEVQLTableHeader;

    // If isToProject,
    var headerStyle = {};
    var componentToDisplay: React.ReactElement = isEmptyObject(
        evqlTableHeader
    ) ? (
        <>{String(column)}</>
    ) : (
        <>{evqlTableHeader.name}</>
    );
    if (!isEmptyObject(evqlTableHeader) && evqlTableHeader.isToProject) {
        // Highlight the header background
        headerStyle = { background: "#FFDDA7", color: "black" };
        // Get all aggregation functions applied to this column
        const aggFuncs = evqlTableHeader.aggFuncs.map(
            (aggFuncId) => aggFunctions[aggFuncId]
        );
        componentToDisplay = (
            <>
                <>{evqlTableHeader.name}</>
                <br />
                <div style={{ fontSize: "14px" }}>
                    {"(" + aggFuncs.join(", ") + ")"}
                </div>
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
    const {
        evqlRoot,
        setEVQLRoot,
        setSelectedCoordinate,
        childListPath,
        editable,
    } = props;

    // Local context to visualize table
    const [evqlNode, setEVQLNode] = useState({} as EVQLNode);
    const [isFocus, setIsFocus] = useState<boolean>(true);
    const [rowLabels, setRowLabels] = useState<string[]>(["1"]);
    const [tableContext, setTableContext] = useState<IEVQLTable>(
        {} as IEVQLTable
    );

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
                        const conditions: Function[] = parseExpressions(
                            tmp.value,
                            evqlNode.header_names
                        );
                        if (!isEmptyObject(conditions))
                            newClause.conditions.push(...conditions);
                    } catch {
                        console.warn(
                            `Not a complete expression yet: ${tmp.value}`
                        );
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
            return (
                selection !== null &&
                "type" in selection &&
                selection.type === EntireType.Table
            );
        };

        const isEntireColumns = (selection: any) => {
            return (
                selection !== null &&
                "type" in selection &&
                selection.type === EntireType.Column
            );
        };

        const isEntireRows = (selection: any) => {
            return (
                selection !== null &&
                "type" in selection &&
                selection.type === EntireType.Row
            );
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
        if (setSelectedCoordinate) setSelectedCoordinate(newCoordinate);
    };

    const addRowHandler: React.MouseEventHandler = () => {
        if (editable) {
            evqlNode.predicate.clauses.push({ conditions: [] });
            setEVQLRoot(Object.assign({}, evqlRoot));
        }
    };

    const removeRowHandler: React.MouseEventHandler = (event) => {
        const idx: number = parseInt(event?.currentTarget?.id);
        if (editable) {
            evqlNode.predicate.clauses.splice(idx, 1);
            setEVQLRoot(Object.assign({}, evqlRoot));
        }
    };

    useEffect(() => {
        if (evqlRoot) {
            const node = getNode(evqlRoot, [...childListPath]);
            const tmpTableContext = EVQLNodeToEVQLTable(node, editable);
            const tmpRowLabels = Array.from(
                { length: tmpTableContext.rows.length },
                (x, i) => i + 1
            ).map((x) => x.toString());
            setEVQLNode(node);
            setTableContext(tmpTableContext);
            setRowLabels(tmpRowLabels);
        }
    }, [evqlRoot]);

    if (!isEmptyObject(tableContext)) {
        return (
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
                                  if (event.key == "Enter")
                                      setEVQLRoot(Object.assign({}, evqlRoot));
                              }
                            : undefined
                    }
                    onSelect={editable ? onSelectHandler : undefined}
                    ColumnIndicator={EVQLColumnIndicator}
                    DataViewer={(e) => dataViewer(e)}
                />
                <div style={{ display: "inline-block" }}>
                    {evqlNode?.predicate?.clauses.map((clause, idx) => (
                        <div key={idx}>
                            {evqlNode?.predicate?.clauses.length > 1 &&
                            editable ? (
                                <AiOutlineMinusSquare
                                    size={27}
                                    id={String(idx)}
                                    onClick={removeRowHandler}
                                />
                            ) : null}
                            {idx == evqlNode?.predicate?.clauses.length - 1 &&
                            editable ? (
                                <AiOutlinePlusSquare
                                    size={27}
                                    onClick={addRowHandler}
                                />
                            ) : null}
                            <br />
                        </div>
                    ))}
                </div>
            </div>
        );
    }
    return <></>;
};

export const EVQLTables = (props: EVQLTreeWrapperProps) => {
    const {
        evqlRoot,
        setEVQLRoot,
        setSelectedCoordinate,
        editable = true,
    } = props;
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
        const newTree = addEVQLNode(
            evqlRoot,
            [...evqlRoot.node.header_names].concat(newlyprojectNames)
        );
        setEVQLRoot(newTree);
    };

    const removeTableHandler: React.MouseEventHandler = (event) => {
        if (evqlRoot.children.length === 0) {
            alert("Cannot remove the last table");
            return;
        }
        // Check if any predicates or projections. If so, ask for confirmation
        if (
            evqlRoot.node.projection.headers.length > 0 ||
            (evqlRoot.node.predicate.clauses.length > 0 &&
                evqlRoot.node.predicate.clauses[0].conditions.length > 0)
        ) {
            if (
                !window.confirm("Are you sure you want to delete this table?")
            ) {
                return;
            }
        }

        // TODO: need to change data structure of EVQL.
        const subTree = evqlRoot.children[0];
        setEVQLRoot(subTree);
    };

    return (
        <div style={{ overflow: "scroll" }}>
            {isEmptyObject(evqlRoot)
                ? null
                : childPathLists.map((path: number[], index: number) => (
                      <div key={index}>
                          {index + 1 == childPathLists.length ? (
                              <div style={{ display: "inline-block" }}>
                                  <button onClick={addTableHandler}>
                                      Add table
                                  </button>
                                  {index === 0 ? null : (
                                      <button
                                          onClick={removeTableHandler}
                                          style={{ marginLeft: "2px" }}
                                      >
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
                              editable={
                                  editable && index + 1 == childPathLists.length
                              }
                          />
                          <br />
                          <br />
                      </div>
                  ))}
        </div>
    );
};

export default EVQLTable;
