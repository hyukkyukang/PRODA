import { Typography } from "antd";
import React from "react";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import ITutorialSection from "./abstractSection";
import Divider from "@mui/material/Divider";
export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>
            To perform selection on aggregated results, we first write an EVQA with grouping operation. And we write another EVQA with a condition on the result
            of the first EVQA query.
        </p>
    </>
);

// Demo EVQA and results
const headers = ["cars"].concat(demoTable.headers);
// Case 1 query1
const exampleEQVA1_1: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers,
        projection: {
            headers: [
                { id: headers.indexOf("cars"), agg_type: aggFunctions.indexOf("count"), limit: false, limit_num: 0 },
                { id: headers.indexOf("model"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [{ header_id: headers.indexOf("model"), func_type: "Grouping" }],
                },
            ],
        },
    },
    children: [],
};
const headerInfo1_1: PGResultFieldInterface[] = [
    { name: "count", format: "number" },
    { name: "model", format: "string" },
];

const data1_1 = [
    [1, "ford"],
    [1, "cherolet"],
    [1, "toyota"],
    [1, "volkswagen"],
    [1, "amc"],
    [1, "pontiac"],
    [1, "datsun"],
    [2, "hyundai"],
    [1, "kia"],
    [2, "genesis"],
];
const exampleTable1_1: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data1_1,
    fields: headerInfo1_1,
    rosAsArray: false,
};
const exampleResult1_1: ITableExcerpt = PGResultToTableExcerpt(exampleTable1_1);

// Case 1 query1
const headers1_2 = ["Result1", "count", "model"];
const exampleEQVA1_2: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers1_2,
        projection: {
            headers: [
                { id: headers1_2.indexOf("count"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
                { id: headers1_2.indexOf("model"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [{ header_id: headers1_2.indexOf("count"), func_type: "Selecting", op_type: binaryOperators.indexOf(">") + 1, r_operand: "1" }],
                },
            ],
        },
    },
    children: [],
};
const headerInfo1_2: PGResultFieldInterface[] = [
    { name: "count", format: "number" },
    { name: "model", format: "string" },
];

const data1_2 = [
    [2, "hyundai"],
    [2, "genesis"],
];
const exampleTable1_2: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data1_2,
    fields: headerInfo1_2,
    rosAsArray: false,
};
const exampleResult1_2: ITableExcerpt = PGResultToTableExcerpt(exampleTable1_2);

// Case 2 query1
const exampleEQVA2_1: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers,
        projection: {
            headers: [
                { id: headers.indexOf("model"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
                { id: headers.indexOf("horsepower"), agg_type: aggFunctions.indexOf("avg"), limit: false, limit_num: 0 },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [{ header_id: headers.indexOf("model"), func_type: "Grouping" }],
                },
            ],
        },
    },
    children: [],
};
const headerInfo2_1: PGResultFieldInterface[] = [
    { name: "model", format: "string" },
    { name: "horsepower", format: "number" },
];

const data2_1 = [
    ["ford", 10],
    ["cherolet", 10],
    ["toyota", 10],
    ["volkswagen", 10],
    ["amc", 10],
    ["pontiac", 10],
    ["datsun", 10],
    ["hyundai", 10.5],
    ["kia", 10],
    ["genesis", 10.5],
];
const exampleTable2_1: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data2_1,
    fields: headerInfo2_1,
    rosAsArray: false,
};
const exampleResult2_1: ITableExcerpt = PGResultToTableExcerpt(exampleTable2_1);

const new_input_table_header_info: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "model", format: "string" },
    { name: "horsepower", format: "number" },
    { name: "max_speed", format: "number" },
    { name: "year", format: "number" },
    { name: "price", format: "number" },
    { name: "model", format: "string" },
    { name: "horsepower", format: "number" },
];

const new_table_data = [
    [
        1,
        "ford",
        10,
        230,
        2010,
        31000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        2,
        "cherolet",
        10,
        330,
        2010,
        41000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        3,
        "toyota",
        10,
        430,
        2011,
        41000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        4,
        "volkswagen",
        10,
        530,
        2011,
        51000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        5,
        "amc",
        10,
        630,
        2012,
        61000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        6,
        "pontiac",
        10,
        730,
        2012,
        71000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        7,
        "datsun",
        10,
        830,
        2013,
        81000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        8,
        "hyundai",
        10,
        930,
        2013,
        91000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        9,
        "hyundai",
        11,
        940,
        2014,
        92000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        10,
        "kia",
        10,
        1030,
        2014,
        101000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        11,
        "genesis",
        10,
        1130,
        2014,
        111000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
    [
        12,
        "genesis",
        11,
        1140,
        2015,
        112000,
        ["ford", "cherolet", "toyota", "volkswagen", "amc", "pontiac", "datsun", "hyundai", "kia", "genesis"],
        [10, 10, 10, 10, 10, 10, 10, 10.5, 10, 10.5],
    ],
];

const new_input_table_pg: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: new_table_data,
    fields: new_input_table_header_info,
    rosAsArray: false,
};
const new_input_table: ITableExcerpt = PGResultToTableExcerpt(new_input_table_pg);

const headers2_2 = ["id", "model", "horsepower", "max_speed", "year", "result1_model", "result1_horsepower"];
const exampleEQVA2_2: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers2_2,
        projection: {
            headers: [
                { id: headers2_2.indexOf("id"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
                { id: headers2_2.indexOf("model"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [
                        {
                            header_id: headers2_2.indexOf("model"),
                            func_type: "Selecting",
                            op_type: binaryOperators.indexOf("=") + 1,
                            r_operand: `$${headers2_2.indexOf("result1_model")}`,
                        },
                        {
                            header_id: headers2_2.indexOf("horsepower"),
                            func_type: "Selecting",
                            op_type: binaryOperators.indexOf(">") + 1,
                            r_operand: `$${headers2_2.indexOf("result1_horsepower")}}`,
                        },
                    ],
                },
            ],
        },
    },
    children: [],
};
const headerInfo2_2: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "model", format: "string" },
];

const data2_2 = [
    [9, "hyundai"],
    [12, "genesis"],
];
const exampleTable2_2: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data2_2,
    fields: headerInfo2_2,
    rosAsArray: false,
};
const exampleResult2_2: ITableExcerpt = PGResultToTableExcerpt(exampleTable2_2);

const ownDescription = (
    <div style={{ width: 700, whiteSpace: "pre-line" }}>
        <Typography>
            EVQA is capable of operating on the output of another EVQA, and there are two distinct methods in which this can be done. The first involves using
            the output directly as an input table for another EVQA, while the second entails concatenating the output with other tables and subsequently
            utilizing the resulting table as input for another EVQA. Detailed illustrations of both approaches are provided below.
        </Typography>
        <br />
        <h1>Case 1</h1>
        <Typography>Here we explain the first case where the output of an EVQA is directly used as an input table for another EVQA.</Typography>
        <br />
        <h3>
            Input table <i>Cars</i>
        </h3>
        <TableExcerpt queryResult={demoTable} />
        <EVQATables evqaRoot={exampleEQVA1_1} editable={false} prefixDescription={<h3>EVQA1:</h3>} />
        <Typography>This EVQA groups the data by the name of model, and the displays the number of data present for each model.</Typography>
        <br />
        <br />
        <h3>Result1:</h3>
        <TableExcerpt queryResult={exampleResult1_1} />
        <Typography>Here is the result table of the EVQA1. Note that this will be used as the input table for the following EVQA2.</Typography>

        <EVQATables evqaRoot={exampleEQVA1_2} editable={false} prefixDescription={<h3>EVQA2:</h3>} />
        <Typography>This EVQA filters data in which the model count is less than one.</Typography>
        <br />
        <br />
        <h3>Final Result:</h3>
        <TableExcerpt queryResult={exampleResult1_2} />
        <Divider />
        <br />
        <h1>Case 2</h1>
        <Typography>
            Here we explain the second case where the output of an EVQA is concatenated with another table and used as an input table for another EVQA.
        </Typography>
        <br />
        <h3>
            Input table <i>cars</i>
        </h3>
        <TableExcerpt queryResult={demoTable} />
        <EVQATables evqaRoot={exampleEQVA2_1} editable={false} prefixDescription={<h3>EVQA1</h3>} />
        <br />
        <h3>Result1:</h3>
        <TableExcerpt queryResult={exampleResult2_1} />
        <br />
        <h3>New input table:</h3>
        <TableExcerpt queryResult={new_input_table} />
        <Typography>
            A new table is constructed by concatenateing the result table (i.e. Result1) with the original input table. Now this new table is used as an input
            table to the following EVQA (i.e. EVQA2).
        </Typography>
        <EVQATables evqaRoot={exampleEQVA2_2} editable={false} prefixDescription={<h3>EVQA2</h3>} />
        <Typography>
            The second EVQA utilizes the outcome of the initial EVQA to find the ID of the model whose horsepower is higher than the mean horsepower of that
            specific model.
        </Typography>
        <br />
        <br />
        <h3>Final Result:</h3>
        <TableExcerpt queryResult={exampleResult2_2} />
    </div>
);

export const Selection3Section: ITutorialSection = {
    title: "Reusing Results",
    description: "EVQA can perform operation over result of another EVQA.",
    exampleDescription: <></>,
    syntaxDescription: SyntaxDescription,
    itsOwnPage: ownDescription,
};

export default Selection3Section;

// The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.
