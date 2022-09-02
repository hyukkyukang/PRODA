import React, { useEffect, useState, useRef } from "react";
import { Spreadsheet, DataViewerComponent, Matrix, CellBase, ColumnIndicatorComponent, Point } from "react-spreadsheet-custom";
import { AiOutlinePlusSquare, AiOutlineMinusSquare } from "react-icons/ai";

import { EVQLTree, EVQLNode, parseExpressions, aggFunctions, Function, Clause } from "./EVQL";
import { getNode, EVQLNodeToEVQLTable, getTreeTraversingPaths } from "./utils";
import { isEmptyObject } from "../../utils";
import classNames from "classnames";

import { Box, Input } from "@mui/material";

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
};

export interface IEVQLTableHeader {
    name: string;
    aggFuncs: number[];
    isToProject: boolean;
};

export interface IEVQLTable {
    headers: IEVQLTableHeader[];
    rows: Matrix<CellBase<React.ReactElement>>;
};

export interface IEVQLVisualizationContext {
    evqlRoot: EVQLTree;
    setEVQLRoot: React.Dispatch<React.SetStateAction<EVQLTree>>;
    setSelectedCoordinate?: React.Dispatch<React.SetStateAction<Coordinate | undefined>>;
    childListPath: number[];
    editable: boolean;
};

export interface EVQLTreeWrapperProps {
    evqlRoot: EVQLTree;
    setEVQLRoot: React.Dispatch<React.SetStateAction<EVQLTree>>;
    setSelectedCoordinate?: React.Dispatch<React.SetStateAction<Coordinate | undefined>>;
    editable?: boolean;
};

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
    var componentToDisplay: React.ReactElement = isEmptyObject(evqlTableHeader) ? <>{String(column)}</> : <>{evqlTableHeader.name}</>;
    if (!isEmptyObject(evqlTableHeader) && evqlTableHeader.isToProject) {
        // Highlight the header background
        headerStyle = {background: "#FFDDA7", color: "black"};
        // Get all aggregation functions applied to this column
        const aggFuncs = evqlTableHeader.aggFuncs.map(aggFuncId => aggFunctions[aggFuncId]);
        componentToDisplay = <>
            <>{evqlTableHeader.name}</>
            <br/>
            <div style={{fontSize: "14px"}}> 
                {"("+aggFuncs.join(", ")+")"}
            </div>
        </>;
    }

    return (
    <th className={classNames("Spreadsheet__header", {"Spreadsheet__header--selected": selected,})}
        onClick={handleClick} tabIndex={0}
        style={headerStyle}>
        {componentToDisplay}
    </th>);
};


export const EVQLTable = (props: IEVQLVisualizationContext) => {
    const {evqlRoot, setEVQLRoot, setSelectedCoordinate, childListPath, editable} = props;
    
    // Local context to visualize table
    const [evqlNode, setEVQLNode] = useState({} as EVQLNode);
    const [isFocus, setIsFocus] = useState<boolean>(true);
    const [rowLabels, setRowLabels] = useState<string[]>(["1"]);
    const [tableContext, setTableContext] = useState<IEVQLTable>({} as IEVQLTable);
    // Local context for add Row button
    const [isHoveringAddRow, setIsHoveringAddRow] = useState<boolean>(false);
    const addRowRef = useRef<HTMLButtonElement>(null);

    const dataViewer: DataViewerComponent<CellBase<any>> = (cellData) => {
        if (cellData.cell){
            const value = cellData.cell.value;
            return <>{value}</>;
        }
        return <></>;
    };

    const onChangeHandler = (newRows: Matrix<CellBase<any>>): void => {
        // Create new EVQLNode
        evqlNode.predicate.clauses = [];
        for (let i=0; i<newRows.length; i++){
            const newClause: Clause = {"conditions": []};
            for (let j=0; j<newRows[i].length; j++){
                const tmp = newRows[i][j];
                if (tmp && tmp.value != null){
                    try{
                        // Create a condition
                        const conditions: Function[] = parseExpressions(tmp.value, evqlNode.header_names);
                        if (!isEmptyObject(conditions)) newClause.conditions.push(...conditions);
                    }
                    catch {
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
        var newCoordinate = {"tableIndices":[],"rowIdx": -1, "colIdx": -1};
        if (isPointRange(selection)) {
            newCoordinate["rowIdx"] = points[0].row;
            newCoordinate["colIdx"] = points[0].column;
        }
        else if (isEntireTable(selection)){
        }
        else if (isEntireColumns(selection)){
            newCoordinate["colIdx"] = points[0].column;
        }
        else if (isEntireRows(selection)){
            console.log(`Entire rows selected`);
            newCoordinate["rowIdx"] = points[0].row;
        }
        else {
            return;
        }
        if (setSelectedCoordinate)
            setSelectedCoordinate(newCoordinate);
    };

    const addRowHandler: React.MouseEventHandler = () => {
        if (editable){
            evqlNode.predicate.clauses.push({"conditions": []});
            setEVQLRoot(Object.assign({}, evqlRoot));
        }
    };

    const removeRowHandler: React.MouseEventHandler = (event) => {
        console.log(`Clicked on remove row button: ${JSON.stringify(event.currentTarget.id)}`);
        const idx: number = parseInt(event?.currentTarget?.id);
        if (editable){
            evqlNode.predicate.clauses.splice(idx, 1);
            setEVQLRoot(Object.assign({}, evqlRoot));
        }
    };

    useEffect(() => {
        if (evqlRoot){
            const node = getNode(evqlRoot, [...childListPath]);
            const tmpTableContext = EVQLNodeToEVQLTable(node, editable);
            const tmpRowLabels = Array.from({length: tmpTableContext.rows.length}, (x, i) => i+1).map(x => x.toString());
            setEVQLNode(node);
            setTableContext(tmpTableContext);
            setRowLabels(tmpRowLabels);
        }
    }, [evqlRoot]);

    if (!isEmptyObject(tableContext)){
        return (
            <div style={{display: "inline-block"}}>
                <Spreadsheet className="table_sketch" data={tableContext.rows}
                 columnLabels={tableContext.headers} rowLabels={rowLabels}
                 onChange={onChangeHandler}
                 onKeyDown={event => {if (event.key == "Enter") setEVQLRoot(Object.assign({}, evqlRoot))}}
                 onSelect={onSelectHandler}
                 ColumnIndicator={EVQLColumnIndicator}
                 DataViewer={e => dataViewer(e)}/>
                {/* <Box ref={addRowRef}> */}
                <div style={{display:"inline-block"}}>
                {evqlNode?.predicate?.clauses.map((clause, idx) => (
                    <>
                    {evqlNode?.predicate?.clauses.length > 1 && editable ? <AiOutlineMinusSquare size={27} id={String(idx)} onClick={removeRowHandler}/> : null}
                    {(idx == evqlNode?.predicate?.clauses.length-1 && editable) ? <AiOutlinePlusSquare size={27} onClick={addRowHandler}/>: null}
                    <br/>
                    </>
                ))}
                </div>
            </div>
        );
    }
    return <></>;
};

export const EVQLTables = (props: EVQLTreeWrapperProps) => {
    const {evqlRoot, setEVQLRoot, setSelectedCoordinate, editable = true} = props;
    return (
        <div style={{overflow: "scroll"}}>
            {isEmptyObject(evqlRoot) ? null : getTreeTraversingPaths(evqlRoot).map((path: number[], index: number) => (
            <div key={index}>
                <EVQLTable evqlRoot={evqlRoot} setEVQLRoot={setEVQLRoot} setSelectedCoordinate={setSelectedCoordinate} childListPath={path} editable={editable}/>
                <br/>
            </div>))}
        </div>);
};

export default EVQLTable;
