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
        <p>EVQA writes conditions in a separate row to express OR conditions.</p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionOrSyntaxExample.rows}
            columnLabels={SelectionOrSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
        <br />
        <br />
        <p>EVQA writes conditions in the same row to express AND conditions between different columns.</p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionAndSyntaxExample.rows}
            columnLabels={SelectionAndSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />

        <br />
        <br />
        <p>EVQA uses AND operator to express AND conditions on the same column.</p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionAndOnCellSyntaxExample.rows}
            columnLabels={SelectionAndOnCellSyntaxExample.headers}
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
                { id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
                { id: headers.indexOf("price"), agg_type: aggFunctions.indexOf("none"), limit: false, limit_num: 0 },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [
                        { header_id: headers.indexOf("model"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "genesis" },
                        { header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2014" },
                    ],
                },
                {
                    conditions: [
                        { header_id: headers.indexOf("model"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "genesis" },
                        { header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2015" },
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
const data = [
    [11, 111000],
    [12, 112000],
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
        <TableExcerpt queryResult={demoTable} />
        <p>
            {
                'The following EVQA applies conditons on the column "model" and "year".\nIt returns records that has model equal to "genesis" and year is equal to 2014 or 2015'
            }
        </p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Selection2Section: ITutorialSection = {
    title: "And, Or",
    description: "EVQA can apply multiple conditions with AND and OR.",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Selection2Section;
