import { ITableExcerpt } from "./TableExcerpt";

export interface PGResultFieldInterface {
    name: string;
    tableID: number;
    columnID: number;
    dataTypeID: number;
    dataTypeSize: number;
    dataTypeMOdifier: number;
    format: string;
}

export interface PGResultInterface {
    command: string;
    rowCount: number;
    oid: number | null;
    rows: any[][];
    fields: PGResultFieldInterface[];
    rosAsArray: boolean;
    // Below attributes are not used in this component
    _parsers: any;
    _types: any;
    RowCtor: any;
}

export const PGResultToTableExcerpt = (pgResult: PGResultInterface): ITableExcerpt => {
    const table = {
        name: "result",
        headers: pgResult.fields.map((field) => field.name),
        col_types: pgResult.fields.map((field) => field.format),
        allow_null: true,
        rows: pgResult.rows.map((row) => {
            return {
                cells: row.map((cell) => {
                    return {
                        value: cell,
                    };
                }),
            };
        }),
    };
    return table;
};
