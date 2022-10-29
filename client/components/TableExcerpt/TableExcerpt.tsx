import "antd/dist/antd.css";
import { isEmptyObject } from "../../utils";
import { Table } from "antd";
import type { ColumnsType } from "antd/es/table";

export interface Cell {
    value: any;
}

export interface Row {
    cells: Cell[];
}

// This is for table exceprt
export interface ITableExcerpt {
    name: string;
    headers: string[];
    col_types: string[];
    rows: Row[];
    base_table_names: string[];
}

const toAntdColumns = (tableExcerpt: ITableExcerpt): ColumnsType<any> => {
    const columns: ColumnsType<any> = [];
    tableExcerpt.headers.forEach((headerName, idx) => {
        columns.push({
            title: headerName,
            dataIndex: headerName,
            render: (text) => <a>{text}</a>,
            onCell: (_, index) => ({
                colSpan: 1,
            }),
        });
    });

    return columns;
};

const toAntdDataSource = (tableExcerpt: ITableExcerpt): any[] => {
    const data: any[] = [];
    tableExcerpt.rows.forEach((row, rowIdx) => {
        const datum: any = {};
        row.cells.forEach((cell, colIdx) => {
            datum[tableExcerpt.headers[colIdx]] = cell.value;
        });
        data.push(datum);
    });
    return data;
};

const isEmptyRow = (tableExcerpt: ITableExcerpt): boolean => {
    return isEmptyObject(tableExcerpt) || isEmptyObject(tableExcerpt.headers) || isEmptyObject(tableExcerpt.rows) || tableExcerpt.rows.length == 0;
};

export const TableExcerpt = (props: React.ComponentProps<any>) => {
    const tableExcerpt: ITableExcerpt = props.queryResult;
    // Handle empty table
    if (isEmptyObject(tableExcerpt)) {
        return <></>;
    } else if (isEmptyRow(tableExcerpt)) {
        return <div style={{ marginLeft: "10px" }}>(0 rows)</div>;
    }
    // Render table with data
    return (
        <>
            <Table columns={toAntdColumns(tableExcerpt)} dataSource={toAntdDataSource(tableExcerpt)} bordered />
        </>
    );
};

export default TableExcerpt;
