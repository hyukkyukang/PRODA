import { ITableExcerpt } from "./TableExcerpt";
import { isNumber, isEmptyObject } from "../../utils";
import { getEmptyTableExcerpt } from "./TableExcerpt";

export interface PGResultFieldInterface {
    name: string;
    format: string;
    tableID?: number;
    columnID?: number;
    dataTypeID?: number;
    dataTypeSize?: number;
    dataTypeMOdifier?: number;
}

export interface PGResultInterface {
    rows: any[][];
    fields: PGResultFieldInterface[];
    command?: string;
    rowCount?: number;
    oid?: number | null;
    rosAsArray?: boolean;
    // Below attributes are not used in this component
    _parsers?: any;
    _types?: any;
    RowCtor?: any;
}

export const PGResultToTableExcerpt = (pgResult: PGResultInterface): ITableExcerpt => {
    if (pgResult === undefined || pgResult == null || isEmptyObject(pgResult)) {
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
