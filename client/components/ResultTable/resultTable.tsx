import React from "react";
import { ReactGrid, Column, Row, HeaderCell, TextCell, NumberCell } from "@silevis/reactgrid";
import "@silevis/reactgrid/styles.css";
import { isEmptyObject, isNumber } from "../../utils";
import { PGResultInterface } from "../VQL/Postgres";
import { Table } from "../VQL/TableExcerpt";

const recomCellSizeFor = (value: string): number => {
    return Math.floor(value.length / 6) * 50 + 80;
};

const toReactGridColumn = (table: Table): Column[] => {
    const colInfos: Column[] = [];
    table.headers.forEach((headerName, idx) => {
        colInfos.push({ columnId: headerName, width: recomCellSizeFor(headerName) });
    });
    return colInfos;
};

const toReactGridRows = (table: Table): Row[] => {
    const rows: Row[] = [];
    const headerCells: HeaderCell[] = [];
    // Create header cells
    table.headers.forEach((headerName, idx) => {
        headerCells.push({ type: "header", text: headerName });
    });
    rows.push({ rowId: "header", cells: headerCells });

    // Create data cells
    table.rows.forEach((row, rowIdx) => {
        const cells: (TextCell | NumberCell)[] = [];
        for (var idx = 0; idx < row.cells.length; idx++) {
            const value = row.cells[idx].value;
            if (isNumber(value.toString())) {
                cells.push({ type: "number", value: parseFloat(value) });
            } else {
                cells.push({ type: "text", text: value });
            }
        }
        rows.push({ rowId: rowIdx, cells: cells });
    });

    return rows;
};

export const ResultTable = (props: React.ComponentProps<any>) => {
    const queryResult: Table = props.queryResult;
    if (!isEmptyObject(queryResult)) {
        if (isEmptyObject(queryResult.headers) || isEmptyObject(queryResult.rows) || queryResult.rows.length == 0) {
            return <div style={{ marginLeft: "10px" }}>(0 rows)</div>;
        }
        return (
            <>
                <ReactGrid rows={toReactGridRows(queryResult)} columns={toReactGridColumn(queryResult)} />
            </>
        );
    }
    return <></>;
};

export default ResultTable;
