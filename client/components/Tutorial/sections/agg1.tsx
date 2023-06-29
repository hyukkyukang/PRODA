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
        <p>{'Below illustrates how min operation is applied in EVQA. It applies min function on "column1"'}</p>
        <Spreadsheet className="syntaxExample" data={MinSyntaxExample.rows} columnLabels={MinSyntaxExample.headers} ColumnIndicator={EVQAColumnIndicator} />
        <br />
        <br />
        <p>{"In fact, more than one function can be used simultaneously."}</p>
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
                { id: headers.indexOf("horsepower"), agg_type: aggFunctions.indexOf("max"), limit: false, limit_num: 0 },
                { id: headers.indexOf("max_speed"), agg_type: aggFunctions.indexOf("min"), limit: false, limit_num: 0 },
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
        <TableExcerpt queryResult={demoTable} />
        <p>{'The following EVQA lists the maximum "horsepower" and the minimum "max_speed" of cars'}</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const Agg1Section: ITutorialSection = {
    title: "Min and Max",
    description:
        'The "Min" and "Max" functions return the smallest and largest values of the selected column, respectively. These functions can only be applied on columns that are selected to be shown in the reuslt.',
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default Agg1Section;
