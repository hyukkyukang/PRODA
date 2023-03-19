import React from "react";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import ITutorialSection from "./abstractSection";
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
                { id: headers.indexOf("cars"), agg_type: aggFunctions.indexOf("count") },
                { id: headers.indexOf("model"), agg_type: aggFunctions.indexOf("none") },
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
                { id: headers1_2.indexOf("count"), agg_type: aggFunctions.indexOf("none") },
                { id: headers1_2.indexOf("model"), agg_type: aggFunctions.indexOf("none") },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [{ header_id: headers1_2.indexOf("model"), func_type: "Selecting", op_type: binaryOperators.indexOf(">") + 1, r_operand: "1" }],
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

// Case 1 query1
const exampleEQVA2_1: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers,
        projection: {
            headers: [
                { id: headers.indexOf("cars"), agg_type: aggFunctions.indexOf("count") },
                { id: headers.indexOf("model"), agg_type: aggFunctions.indexOf("none") },
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
    { name: "count", format: "number" },
    { name: "model", format: "string" },
];

const data2_1 = [
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
const exampleTable2_1: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data2_1,
    fields: headerInfo2_1,
    rosAsArray: false,
};
const exampleResult2_1: ITableExcerpt = PGResultToTableExcerpt(exampleTable2_1);

const ownDescription = (
    <div style={{ width: 600, whiteSpace: "pre-line" }}>
        <p>
            {
                "EVQA can perform operation over the result of another EVQA. \
                In fact, there are two different ways in which the result of an EVQA can be used by another EVQA.\n\
                Frist, the result can be used directly as an input table to another EVQA. \
                Second, the result can be used to concatenate with other table and used as the input table to another EVQA. \
                Examples for each cases are described below."
            }
        </p>
        <h1>Example 1 (case 1)</h1>
        <p> Below is the table "Cars" </p>
        <TableExcerpt queryResult={demoTable} />
        <EVQATables evqaRoot={exampleEQVA1_1} editable={false} />
        <h2>Result1:</h2>
        <TableExcerpt queryResult={exampleResult1_1} />

        <EVQATables evqaRoot={exampleEQVA1_2} editable={false} />
        <h2>Final Result:</h2>
        <TableExcerpt queryResult={exampleResult1_2} />

        <h1>Example 2 (case 2)</h1>
        <p> Below is the table "Cars" </p>
        <TableExcerpt queryResult={demoTable} />
        <EVQATables evqaRoot={exampleEQVA1_1} editable={false} />
        <h2>Result1:</h2>
        <TableExcerpt queryResult={exampleResult1_1} />

        <EVQATables evqaRoot={exampleEQVA1_2} editable={false} />
        <h2>Final Result:</h2>
        <TableExcerpt queryResult={exampleResult1_2} />
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
