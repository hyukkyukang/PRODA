import React from "react";
import { ReactGrid, Column, Row, HeaderCell, TextCell, NumberCell } from "@silevis/reactgrid";
import "@silevis/reactgrid/styles.css";
import { isEmptyObject, isNumber } from "../../utils";

const recomCellSizeFor = (value: string): number => {
    return Math.floor(value.length / 6) * 50 + 80;
};

const queryResultToReactGridTable = (queryResult: any[]) => {
    const columnNames = Object.keys(queryResult[0]);
    const rows: Row[] = [];
    const colInfos: Column[] = [];
    const headerCells: HeaderCell[] = [];

    for (var idx = 0; idx < columnNames.length; idx++) {
        const colName = columnNames[idx];
        colInfos.push({ columnId: colName, width: recomCellSizeFor(colName) });
        headerCells.push({ type: "header", text: colName });
    }

    rows.push({ rowId: "header", cells: headerCells });

    for (var idx = 0; idx < queryResult.length; idx++) {
        const cells: (TextCell | NumberCell)[] = [];
        columnNames.forEach((colName) => {
            const value = queryResult[idx][colName];
            if (isNumber(value.toString())) {
                cells.push({ type: "number", value: parseFloat(value) });
            } else {
                cells.push({ type: "text", text: value });
            }
        });
        rows.push({ rowId: idx, cells: cells });
    }
    return { rows: rows, columns: colInfos };
};

export const ResultTable = (props: React.ComponentProps<any>) => {
    const queryResult = props.queryResult;
    if (Array.isArray(queryResult)) {
        if (queryResult.length == 0) {
            return <div style={{ marginLeft: "10px" }}>(0 rows)</div>;
        }
        const gridTable = queryResultToReactGridTable(queryResult);
        return (
            <>
                <ReactGrid rows={gridTable.rows} columns={gridTable.columns} />
            </>
        );
    }
    return <></>;
};

export default ResultTable;
