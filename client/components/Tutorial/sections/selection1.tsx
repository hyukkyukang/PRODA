import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { SelectionSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>We can write conditions below any columns to add conditions on those columns.</p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionSyntaxExample.rows}
            columnLabels={SelectionSyntaxExample.headers}
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
            headers: [{ id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("none") }],
        },
        predicate: {
            clauses: [
                { conditions: [{ header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2010" }] },
            ],
        },
    },
    children: [],
};

const headerInfo: PGResultFieldInterface[] = [{ name: "id", format: "number" }];

const data = [
    [1, "ford", 10, 230, 2010, 31000],
    [2, "cherolet", 10, 330, 2010, 41000],
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
        <p>The following EVQA the column id to project and applies condition on the column 'year'. It will return record of cars with year 2010.</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Selection1Section: ITutorialSection = {
    title: "Filter By Condition",
    description: "EVQA Selection is used to filter records.\nIt is used to extract only those records that fufill a specified condition",

    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Selection1Section;
