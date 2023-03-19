import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { GroupingSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>
            'The name of grouping function is "Group". We write grouping expression in the condition of the grouping column, with the name of the column given
            as an input to the grouping function.',
        </p>
        <Spreadsheet
            className="syntaxExample"
            data={GroupingSyntaxExample.rows}
            columnLabels={GroupingSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
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
const headerInfo: PGResultFieldInterface[] = [
    { name: "count", format: "number" },
    { name: "model", format: "string" },
];

const data = [
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
const exampleTable: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data,
    fields: headerInfo,
    rosAsArray: false,
};
const exampleResult: ITableExcerpt = PGResultToTableExcerpt(exampleTable);

const exampleDescription: JSX.Element = (
    <React.Fragment>
        <p>Below is the demo table</p>
        <TableExcerpt queryResult={demoTable} />
        <p>The following EVQA Groups data by the column 'model' and projects the name and number of models.</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const GroupingSection: ITutorialSection = {
    title: "Grouping",
    description:
        'The Grouping operation groups rows that have the same values into summary rows, like "find the number of customers in each country".\
                \nThe Grouping operation is often used with aggregate functions (e.g. min, max, avg, count, and sum) to group the result-set by one or more columns.',
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default GroupingSection;
