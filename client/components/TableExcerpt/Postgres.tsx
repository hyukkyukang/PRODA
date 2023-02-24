import { ITableExcerpt } from "./TableExcerpt";
import { isNumber } from "../../utils";
import { getEmptyTableExcerpt } from "./TableExcerpt";

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
    if (pgResult === undefined || pgResult == null) {
        return getEmptyTableExcerpt();
    }
    return {
        name: "result",
        headers: pgResult.fields.map((field) => field.name),
        col_types: pgResult.fields.map((field) => field.format),
        rows: pgResult.rows.map((row) => {
            return {
                cells: row.map((cell) => {
                    return {
                        value: cell,
                        dtype: isNumber(cell) ? "number" : "string",
                        is_repeating: false,
                    };
                }),
            };
        }),
        base_table_names: [],
    };
};
