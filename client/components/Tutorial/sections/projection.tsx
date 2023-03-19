import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { ProjectionSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

// Description of the projection section
export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <div style={{ width: 600 }}>
            <p>{"We express select fields by highlighting the columns.\nBelow illustrates EVQA that selects 'column1' to show in the result."}</p>
        </div>
        <Spreadsheet
            className="syntaxExample"
            data={ProjectionSyntaxExample.rows}
            columnLabels={ProjectionSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
    </>
);

// Demo EVQA and results

const headers = ["cars"].concat(demoTable.headers);
const exampleEQVA1: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers,
        projection: {
            headers: [{ id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("none") }],
        },
        predicate: {
            clauses: [],
        },
    },
    children: [],
};

const headerInfo1: PGResultFieldInterface[] = [{ name: "id", format: "number" }];
const data1 = [[1], [2], [3], [4], [5], [6], [7], [8], [9], [1], [1], [1]];
const exampleTable1: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data1,
    fields: headerInfo1,
    rosAsArray: false,
};
const exampleResult1: ITableExcerpt = PGResultToTableExcerpt(exampleTable1);

// Example 2
const exampleEQVA2: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers,
        projection: {
            headers: [
                { id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("none") },
                { id: headers.indexOf("model"), agg_type: aggFunctions.indexOf("none") },
                { id: headers.indexOf("horsepower"), agg_type: aggFunctions.indexOf("none") },
            ],
        },
        predicate: {
            clauses: [],
        },
    },
    children: [],
};

const headerInfo2: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "model", format: "string" },
    { name: "horsepower", format: "number" },
];
const data2 = [
    [1, "ford", 10],
    [2, "cherolet", 10],
    [3, "toyota", 10],
    [4, "volkswagen", 10],
    [5, "amc", 10],
    [6, "pontiac", 10],
    [7, "datsun", 10],
    [8, "hyundai", 10],
    [9, "hyundai", 11],
    [10, "kia", 10],
    [11, "genesis", 10],
    [12, "genesis", 11],
];

const exampleTable2: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data2,
    fields: headerInfo2,
    rosAsArray: false,
};
const exampleResult2: ITableExcerpt = PGResultToTableExcerpt(exampleTable2);

// Example 3
const exampleEQVA3: EVQATree = {
    node: {
        name: "select",
        table_excerpt: demoTable,
        headers: headers,
        projection: {
            headers: [{ id: headers.indexOf("cars"), agg_type: aggFunctions.indexOf("none") }],
        },
        predicate: {
            clauses: [],
        },
    },
    children: [],
};

const headerInfo3: PGResultFieldInterface[] = [
    { name: "id", format: "number" },
    { name: "model", format: "string" },
    { name: "horsepower", format: "number" },
    { name: "max_speed", format: "number" },
    { name: "year", format: "number" },
    { name: "price", format: "number" },
];

const data3 = [
    [1, "ford", 10, 230, 2010, 31000],
    [2, "cherolet", 10, 330, 2010, 41000],
    [3, "toyota", 10, 430, 2011, 41000],
    [4, "volkswagen", 10, 530, 2011, 51000],
    [5, "amc", 10, 630, 2012, 61000],
    [6, "pontiac", 10, 730, 2012, 71000],
    [7, "datsun", 10, 830, 2013, 81000],
    [8, "hyundai", 10, 930, 2013, 91000],
    [9, "hyundai", 11, 940, 2014, 92000],
    [10, "kia", 10, 1030, 2014, 101000],
    [11, "genesis", 10, 1130, 2014, 111000],
    [12, "genesis", 11, 1140, 2015, 112000],
];
const exampleTable3: PGResultInterface = {
    command: "",
    rowCount: 0,
    oid: null,
    rows: data3,
    fields: headerInfo3,
    rosAsArray: false,
};
const exampleResult3: ITableExcerpt = PGResultToTableExcerpt(exampleTable3);

const exampleDescription: JSX.Element = (
    <React.Fragment>
        <TableExcerpt queryResult={demoTable} />
        <p>The following EVQA lists the number of customers in each country:</p>
        <EVQATables evqaRoot={exampleEQVA1} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult1} />
        <br />
        <h1>Example 2 </h1>
        <p>EVQA can select mulitple columns to show in the result table</p>
        <EVQATables evqaRoot={exampleEQVA2} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult2} />
        <h1>Example 3 </h1>
        <p>If EVQA highlights the table name, it means that every columns will be shown in the result</p>
        <EVQATables evqaRoot={exampleEQVA3} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult3} />
    </React.Fragment>
);

export const ProjectionSection: ITutorialSection = {
    title: "Select Fields",
    description:
        "The select field is an operation used to select data from a table.\nThrough select field, EVQA selects which columns will be shown in the operation result.",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default ProjectionSection;
