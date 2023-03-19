import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { MinMaxSyntaxExample, MinSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>"Below EVQA applies min function on 'column1' and max function on 'column2'."</p>
        <Spreadsheet className="syntaxExample" data={MinSyntaxExample.rows} columnLabels={MinSyntaxExample.headers} ColumnIndicator={EVQAColumnIndicator} />
        <br />
        <br />
        <Spreadsheet
            className="syntaxExample"
            data={MinMaxSyntaxExample.rows}
            columnLabels={MinMaxSyntaxExample.headers}
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
                { id: headers.indexOf("horsepower"), agg_type: aggFunctions.indexOf("max") },
                { id: headers.indexOf("max_speed"), agg_type: aggFunctions.indexOf("min") },
            ],
        },
        predicate: {
            clauses: [],
        },
    },
    children: [],
};
const headerInfo: PGResultFieldInterface[] = [
    { name: "horsepower", format: "number" },
    { name: "max_speed", format: "number" },
];
const data = [[1140, 2010]];
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
        <p>"The following EVQA lists the maximum 'horsepower' and the minimum 'max_speed' of cars"</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Agg1Section: ITutorialSection = {
    title: "Min and Max",
    description: "The 'Min' and 'Max' functions return the smallest and largest values of the selected column. respectively.",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Agg1Section;
