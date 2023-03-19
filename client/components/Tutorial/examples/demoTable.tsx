import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt } from "../../TableExcerpt/TableExcerpt";

const headerInfo: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "model", format: "string" },
    { name: "horsepower", format: "number" },
    { name: "max_speed", format: "number" },
    { name: "year", format: "number" },
    { name: "price", format: "number" },
];

const data = [
    [1, "ford", 10, 230, 2010, 31000],
    [2, "cherolet", 10, 330, 2010, 41000],
    [3, "toyota", 10, 430, 2011, 41000],
    [4, "volkswagen", 10, 530, 2011, 51000],
    [5, "amc", 10, 630, 2012, 61000],
    [6, "pontiac", 10, 730, 2012, 71000],
    [7, "datsun", 10, 830, 2013, 81000],
    [8, "hyundai", 10, 930, 2013, 91000],
    [9, "hyundai", 11, 940, 2014, 92000],
    [10, "kia", 10, 1030, 2014, 101000],
    [11, "genesis", 10, 1130, 2014, 111000],
    [12, "genesis", 11, 1140, 2015, 112000],
];

export const demoTableInPG: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data,
    fields: headerInfo,
    rosAsArray: false,
};

export const demoTable: ITableExcerpt = PGResultToTableExcerpt(demoTableInPG);
