import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { SelectionAndOnCellSyntaxExample, SelectionAndSyntaxExample, SelectionOrSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>To combine conditions with OR, write conditions in a separate row.</p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionOrSyntaxExample.rows}
            columnLabels={SelectionOrSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
        <br />
        <br />
        <Spreadsheet
            className="syntaxExample"
            data={SelectionAndOnCellSyntaxExample.rows}
            columnLabels={SelectionAndOnCellSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
        <p>
            To combine conditions with AND, write conditions in the same row. To write a multiple conditions for one column, use the keyword AND to combine two
            different expressions.
        </p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionAndSyntaxExample.rows}
            columnLabels={SelectionAndSyntaxExample.headers}
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
                { id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("none") },
                { id: headers.indexOf("price"), agg_type: aggFunctions.indexOf("none") },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [
                        { header_id: headers.indexOf("model"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "genesis" },
                        { header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2011" },
                    ],
                },
                {
                    conditions: [
                        { header_id: headers.indexOf("model"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "genesis" },
                        { header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2012" },
                    ],
                },
            ],
        },
    },
    children: [],
};
const headerInfo: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "price", format: "string" },
];
const data = [[11, 111000]];
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
        <p>
            The following EVQA applies conditons on column 'model' and 'year'.\nIt returns records that has model equal to 'tesla model x' and year is equal to
            2011 or 2012
        </p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Selection2Section: ITutorialSection = {
    title: "And, Or",
    description: "With EVQA, we can apply multiple conditions with OR or AND operators",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Selection2Section;
