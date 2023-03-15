import "antd/dist/antd.css";
import { isEmptyObject } from "../../utils";
import { Table } from "antd";
import type { ColumnsType } from "antd/es/table";

export interface Cell {
    value: any;
    dtype: string;
    is_repeating: boolean;
}

export interface Row {
    cells: Cell[];
}

export interface ITableExcerpt {
    name: string;
    headers: string[];
    col_types: string[];
    rows: Row[];
    base_table_names: string[];
}

const toAntdColumns = (tableExcerpt: ITableExcerpt, flatRows: Cell[][]): ColumnsType<any> => {
    const columns: ColumnsType<any> = [];
    tableExcerpt.headers.forEach((headerName, colIdx) => {
        // Create mapping of row index to row span size
        const rowSpanMapping: { [key: number]: number } = {};
        var baseRowIdx = 0;
        for (let rowIdx = 0; rowIdx < flatRows.length; rowIdx++) {
            if (flatRows[rowIdx][colIdx].is_repeating) {
                rowSpanMapping[rowIdx] = 0;
                rowSpanMapping[baseRowIdx] += 1;
            } else {
                rowSpanMapping[rowIdx] = 1;
                baseRowIdx = rowIdx;
            }
        }
        // Add definiition for column
        columns.push({
            key: colIdx,
            title: headerName,
            dataIndex: colIdx,
            render: (text) => <a>{text}</a>,
            onCell: (_, index) => ({
                rowSpan: index != undefined ? rowSpanMapping[index] : 1,
                colSpan: 1,
            }),
        });
    });
    return columns;
};

const toAntdDataSource = (flatRows: Cell[][]): any[] => {
    const data: any[] = [];
    // For all rows
    flatRows.forEach((row, rowIdx) => {
        // For a row (i.e. all columns)
        const datum: any = {};
        row.forEach((cell, colIdx) => {
            datum[colIdx] = cell.value;
        });
        data.push(datum);
    });
    return data;
};

const toFlatRow = (row: Row): Cell[][] => {
    // Value to return
    const flattenRows: Cell[][] = [];
    // Local variables
    const nonListIndices = [];
    const listIndices = [];
    const doubleListIndices = [];

    const cells = row.cells;
    // Category columns by their types
    for (var colIdx = 0; colIdx < cells.length; colIdx++) {
        const cell = cells[colIdx];
        if (cell.value instanceof Array && cell.value.length > 1) {
            // Check not double
            if (cell.value[0] instanceof Array) {
                doubleListIndices.push(colIdx);
            } else {
                listIndices.push(colIdx);
            }
        } else {
            nonListIndices.push(colIdx);
        }
    }
    // Create a base row for non-list columns
    const baseRow: Cell[] = [];
    nonListIndices.forEach((colIdx) => {
        baseRow.push({ ...cells[colIdx], is_repeating: false });
    });

    if (listIndices.length == 0) {
        return [baseRow];
    } else {
        // Create a row for each list column
        for (var subRowIdx = 0; subRowIdx < cells[listIndices[0]].value.length; subRowIdx++) {
            const tmpBaseRow: Cell[] = JSON.parse(JSON.stringify(baseRow));
            listIndices.forEach((colIdx) => {
                tmpBaseRow.push({ value: cells[colIdx].value[subRowIdx], dtype: "dummy", is_repeating: false });
            });
            // Mark the non first cell as repeating
            nonListIndices.forEach((colIdx) => {
                tmpBaseRow[colIdx].is_repeating = subRowIdx != 0;
            });
            flattenRows.push(tmpBaseRow);
        }
        if (doubleListIndices.length != 0) {
            // TODO: Recursively call and create more rows
            const tmpFlattenRows = JSON.parse(JSON.stringify(flattenRows));
            for (var subRowIdx = 0; subRowIdx < cells[doubleListIndices[0]].value.length; subRowIdx++) {
                const tmpBaseRow: Cell[] = JSON.parse(JSON.stringify(tmpFlattenRows));
                doubleListIndices.forEach((colIdx) => {
                    tmpFlattenRows.push({ value: cells[colIdx].value, dtype: "dummy", is_repeating: false });
                });
                // Mark the non first cell as repeating
                for (var colIdx = 0; colIdx < tmpBaseRow.length; colIdx++) {
                    tmpBaseRow[colIdx].is_repeating = subRowIdx != 0;
                }
                flattenRows.push(tmpBaseRow);
            }
        }
    }
    return flattenRows;
};

const toFlatRows = (rows: Row[]): Cell[][] => {
    const flattenRows: Cell[][] = [];
    if (isEmptyObject(rows)) {
        return flattenRows;
    }
    for (var rowIdx = 0; rowIdx < rows.length; rowIdx++) {
        const row = rows[rowIdx];
        flattenRows.push(...JSON.parse(JSON.stringify(toFlatRow(row))));
    }
    return flattenRows;
};

const isEmptyRow = (tableExcerpt: ITableExcerpt): boolean => {
    return isEmptyObject(tableExcerpt) || isEmptyObject(tableExcerpt.headers) || isEmptyObject(tableExcerpt.rows) || tableExcerpt.rows.length == 0;
};

export const getEmptyTableExcerpt = (): ITableExcerpt => {
    return {
        name: "",
        headers: [],
        col_types: [],
        rows: [],
        base_table_names: [],
    };
};

export const TableExcerpt = (props: React.ComponentProps<any>) => {
    const tableExcerpt: ITableExcerpt = props.queryResult;
    const flatRows: Cell[][] = isEmptyObject(tableExcerpt) ? [] : toFlatRows(tableExcerpt.rows);
    // Handle empty table
    if (isEmptyObject(tableExcerpt)) {
        return <></>;
    } else if (isEmptyRow(tableExcerpt)) {
        return <div style={{ marginLeft: "10px" }}>No result (0 rows)</div>;
    }
    return (
        <Table
            columns={toAntdColumns(tableExcerpt, flatRows)}
            dataSource={toAntdDataSource(flatRows)}
            bordered
            rowClassName={(record, index) => (index % 2 === 0 ? "table-row-light" : "table-row-dark")}
            style={{ overflow: "auto" }}
        />
    );
};

export default TableExcerpt;
