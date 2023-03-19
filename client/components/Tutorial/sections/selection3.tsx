import React from "react";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, EVQATree } from "../../VQA/EVQA";
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
const exampleEQVA: EVQATree = {
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
const headerInfo: PGResultFieldInterface[] = [{ name: "id", format: "number" }];

const data = [[2], [1]];
export const exampleTable: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data,
    fields: headerInfo,
    rosAsArray: false,
};
export const exampleResult: ITableExcerpt = PGResultToTableExcerpt(exampleTable);

const exampleDescription: JSX.Element = (
    <React.Fragment>
        <p>Below is the demo table</p>
        <TableExcerpt queryResult={demoTable} />
        <p>In the below example, we first group models and find the average max_speed of each model.</p>
        <p>Then, we show the name of models with average max_speed greater than 400.</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Selection3Section: ITutorialSection = {
    title: "Selection on Aggregated Results",
    description: "EVQA allows you to add selection on aggregated results",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Selection3Section;

// The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.
