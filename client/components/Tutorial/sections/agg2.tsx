import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { CountAvgSumSyntaxExample, CountTableSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>{'Below EVQA applies "count", "avg", "sum" functions on "column1", "column2", and "column3" respectively.'}</p>
        <Spreadsheet
            className="syntaxExample"
            data={CountAvgSumSyntaxExample.rows}
            columnLabels={CountAvgSumSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
        <br />
        <br />
        <p>{'Below EVQA applies "count" function on "table name", whole table.'}</p>
        <Spreadsheet
            className="syntaxExample"
            data={CountTableSyntaxExample.rows}
            columnLabels={CountTableSyntaxExample.headers}
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
                { id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("count"), limit: false, limit_num: 0 },
                { id: headers.indexOf("max_speed"), agg_type: aggFunctions.indexOf("avg"), limit: false, limit_num: 0 },
                { id: headers.indexOf("year"), agg_type: aggFunctions.indexOf("sum"), limit: false, limit_num: 0 },
            ],
        },
        predicate: {
            clauses: [],
        },
    },
    children: [],
};
const headerInfo: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "max_speed", format: "number" },
    { name: "price", format: "number" },
];

const data = [[12, 740, 884000]];
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
        <TableExcerpt queryResult={demoTable} />
        <p>The following EVQA lists the number of car ids with the average maximum speed and the total price of cars</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Agg2Section: ITutorialSection = {
    title: "Count, Avg, Sum",
    description:
        'The "Count", "Avg", and "Sum" functions return the number of rows, the average of the selected column, and the sum of the selected column, respectively. "Avg" and "Sum" can only be applied to columns that are seleted to be shown in the result table. However, "Count" can be applied to the table name, which means that it counts the total number of rows in the table.',
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Agg2Section;
