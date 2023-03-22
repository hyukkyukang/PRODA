import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { dataViewer } from "../../VQA/EVQACell";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { SelectionSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";
import OperatorsDescription from "../operatorsDescription";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>We can write conditions below any columns to add conditions for those columns.</p>
        <Spreadsheet
            className="syntaxExample"
            data={SelectionSyntaxExample.rows}
            columnLabels={SelectionSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
            DataViewer={dataViewer}
        />
        <br />
        <br />
        <h2>List of operators and functions</h2>
        <div style={{ width: 1000 }}>{OperatorsDescription}</div>
        <br />
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
        <TableExcerpt queryResult={demoTable} />
        <p>The following EVQA applies conditions on the column 'year'. It selects data in which the year is equal to 2010.</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Selection1Section: ITutorialSection = {
    title: "Filter By Condition",
    description: "EVQA can add conditions to filter data that do not satisfy the given condition.",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Selection1Section;
