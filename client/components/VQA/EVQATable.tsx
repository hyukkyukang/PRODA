import React, { useContext, useEffect, useMemo, useState } from "react";
import { AiOutlineMinusSquare, AiOutlinePlusSquare } from "react-icons/ai";
import { CellBase, DataViewerComponent, Matrix, Point, Spreadsheet } from "react-spreadsheet-custom";

// import { runEVQA, runSQL } from "../../api/connect";
import { isEmptyObject } from "../../utils";
import { CoordinateContext } from "../Collection/querySheet";
import { TableExcerpt } from "../TableExcerpt/TableExcerpt";
import { Clause, EVQANode, EVQATree, Function } from "./EVQA";
import { EVQACell } from "./EVQACell";
import { EVQAColumnIndicator } from "./EVQAColumnIndicator";
import { addEVQANode, EVQANodeToEVQATable, getNode, getProjectedNames, getSubtree, getTreeTraversingPaths, parseExpressions } from "./utils";

// This is from react-spreadsheet-custom/src/selection.ts
export enum EntireType {
    Row = "row",
    Column = "column",
    Table = "table",
}

export interface ITableHeaderContext {
    headerNames: string[];
}
export interface IHoveringDescriptionContext {
    x: number;
    setX: React.Dispatch<React.SetStateAction<number>>;
    y: number;
    setY: React.Dispatch<React.SetStateAction<number>>;
    description: string;
    setDescription: React.Dispatch<React.SetStateAction<string>>;
    isActive: boolean;
    setIsActive: React.Dispatch<React.SetStateAction<boolean>>;
}

export interface IEVQATableHeader {
    name: string;
    aggFuncs: number[];
    isToProject: boolean;
}

export interface Coordinate {
    tableIndices: number[];
    colIdx: number;
    rowIdx: number;
}

export interface IEVQATable {
    headers: IEVQATableHeader[];
    rows: Matrix<CellBase<React.ReactElement>>;
}

export interface IEVQAVisualizationContext {
    evqaRoot: EVQATree;
    setEVQARoot?: React.Dispatch<React.SetStateAction<EVQATree>>;
    setSelectedCoordinate?: React.Dispatch<React.SetStateAction<Coordinate | undefined>>;
    childListPath: number[];
    editable: boolean;
    isFirstNode: boolean | undefined;
}

export interface EVQATreeWrapperProps {
    evqaRoot: EVQATree;
    setEVQARoot?: React.Dispatch<React.SetStateAction<EVQATree>>;
    setSelectedCoordinate?: React.Dispatch<React.SetStateAction<Coordinate | undefined>>;
    editable?: boolean;
}

export const TableHeaderContext = React.createContext({} as ITableHeaderContext);
export const HoveringDescriptionContext = React.createContext({} as IHoveringDescriptionContext);

export const EVQATable = (props: IEVQAVisualizationContext) => {
    const { evqaRoot, setEVQARoot, setSelectedCoordinate, childListPath, editable } = props;

    // Context for the provider
    const [x, setX] = useState(0);
    const [y, setY] = useState(0);
    const [description, setDescription] = useState("");
    const [isActive, setIsActive] = useState(false);

    // Local context to visualize table
    const [evqaNode, setEVQANode] = useState({} as EVQANode);
    const [rowLabels, setRowLabels] = useState<string[]>(["1"]);
    const [tableContext, setTableContext] = useState<IEVQATable>({} as IEVQATable);

    const headerNames = useMemo<string[]>(() => tableContext?.headers?.map((h) => h.name), [tableContext]);

    // To get selected cell information
    const { selectedCoordinate, SetSelectedCoordinate } = useContext(CoordinateContext);

    const dataViewer: DataViewerComponent<CellBase<any>> = (cellData) => {
        if (cellData.cell) {
            const value = cellData.cell.value;
            return <>{value}</>;
        }
        return <></>;
    };

    const onMouseLeave = () => {
        setIsActive(false);
    };

    const onChangeHandler = (newRows: Matrix<CellBase<any>>): void => {
        // Create new EVQANode
        evqaNode.predicate.clauses = [];
        for (let i = 0; i < newRows.length; i++) {
            const newClause: Clause = { conditions: [] };
            for (let j = 0; j < newRows[i].length; j++) {
                const tmp = newRows[i][j];
                if (tmp && tmp.value != null) {
                    try {
                        // Create a condition
                        const conditions: Function[] = parseExpressions(tmp.value, evqaNode.headers);
                        if (!isEmptyObject(conditions)) newClause.conditions.push(...conditions);
                    } catch {
                        console.warn(`Not a complete expression yet: ${tmp.value}`);
                    }
                }
            }
            if (newClause) evqaNode.predicate.clauses.push(newClause);
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
                newCoordinate.x = points[0].column;
                newCoordinate.y = points[0].row;
            } else {
                newCoordinate.x = points[0].column;
                newCoordinate.y = points[0].row + 1;
            }
            if (SetSelectedCoordinate) {
                SetSelectedCoordinate(newCoordinate);
            }
        }
    };

    const addRowHandler: React.MouseEventHandler = () => {
        if (editable && setEVQARoot) {
            evqaNode.predicate.clauses.push({ conditions: [] });
            setEVQARoot(Object.assign({}, evqaRoot));
        }
    };

    const removeRowHandler: React.MouseEventHandler = (event) => {
        const idx: number = parseInt(event?.currentTarget?.id);
        if (editable && setEVQARoot) {
            evqaNode.predicate.clauses.splice(idx, 1);
            setEVQARoot(Object.assign({}, evqaRoot));
        }
    };

    useEffect(() => {
        if (evqaRoot) {
            const node = getNode(evqaRoot, [...childListPath]);
            const tmpTableContext = EVQANodeToEVQATable(node, editable);
            const tmpRowLabels = Array.from({ length: tmpTableContext.rows.length }, (x, i) => i + 1).map((x) => x.toString());
            setEVQANode(node);
            setTableContext(tmpTableContext);
            setRowLabels(tmpRowLabels);
        }
    }, [evqaRoot]);

    if (!isEmptyObject(tableContext)) {
        return (
            <div style={{ overflow: "scroll" }}>
                <h3>EVQA:</h3>
                <div style={{ display: "inline-block" }}>
                    <TableHeaderContext.Provider value={{ headerNames: headerNames }}>
                        <HoveringDescriptionContext.Provider value={{ x, setX, y, setY, description, setDescription, isActive, setIsActive }}>
                            <Spreadsheet
                                className="table_sketch"
                                data={tableContext.rows}
                                columnLabels={tableContext.headers}
                                rowLabels={rowLabels}
                                onChange={editable ? onChangeHandler : undefined}
                                onKeyDown={
                                    editable
                                        ? (event) => {
                                              if (event.key == "Enter" && setEVQARoot) setEVQARoot(Object.assign({}, evqaRoot));
                                          }
                                        : undefined
                                }
                                onSelect={editable ? onSelectHandler : onClickHandler}
                                ColumnIndicator={EVQAColumnIndicator}
                                DataViewer={(e) => dataViewer(e)}
                                Cell={EVQACell}
                                onMouseLeave={onMouseLeave}
                            />
                        </HoveringDescriptionContext.Provider>
                    </TableHeaderContext.Provider>
                    <div style={{ display: "inline-block" }}>
                        {evqaNode?.predicate?.clauses.map((clause, idx) => (
                            <div key={idx}>
                                {evqaNode?.predicate?.clauses.length > 1 && editable ? (
                                    <AiOutlineMinusSquare size={27} id={String(idx)} onClick={removeRowHandler} />
                                ) : null}
                                {idx == evqaNode?.predicate?.clauses.length - 1 && editable ? <AiOutlinePlusSquare size={27} onClick={addRowHandler} /> : null}
                                <br />
                            </div>
                        ))}
                    </div>
                </div>
                <br />
                {isActive ? (
                    <p className="EVQA-description" style={{ left: x + 10, top: y + 10, zIndex: 1 }}>
                        {description}
                    </p>
                ) : null}
            </div>
        );
    }
    return <></>;
};

export const EVQATables = (props: EVQATreeWrapperProps) => {
    const { evqaRoot, setEVQARoot = undefined, setSelectedCoordinate = undefined, editable = true } = props;
    const childPathLists = getTreeTraversingPaths(evqaRoot);

    // Add & remove buttons
    const addTableHandler: React.MouseEventHandler = () => {
        // Check projection exists in the most outer node
        if (evqaRoot.node.projection.headers.length === 0) {
            alert("Please add projection first");
            return;
        }
        // Get names of projection to add to header of new node
        const newlyprojectNames = getProjectedNames(evqaRoot, []);
        // Create new node
        const newTree = addEVQANode(evqaRoot, [...evqaRoot.node.headers].concat(newlyprojectNames));
        if (setEVQARoot) setEVQARoot(newTree);
    };

    const removeTableHandler: React.MouseEventHandler = (event) => {
        if (!evqaRoot.children) {
            alert("Cannot remove the last table");
            return;
        }
        // Check if any predicates or projections. If so, ask for confirmation
        if (
            evqaRoot.node.projection.headers.length > 0 ||
            (evqaRoot.node.predicate.clauses.length > 0 && evqaRoot.node.predicate.clauses[0].conditions.length > 0)
        ) {
            if (!window.confirm("Are you sure you want to delete this table?")) {
                return;
            }
        }

        // TODO: need to change data structure of EVQA.
        const subTree = evqaRoot.children[0];
        if (setEVQARoot) setEVQARoot(subTree);
    };

    return (
        <React.Fragment>
            {isEmptyObject(evqaRoot)
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
                          <EVQATable
                              evqaRoot={evqaRoot}
                              setEVQARoot={setEVQARoot}
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

export default EVQATable;
