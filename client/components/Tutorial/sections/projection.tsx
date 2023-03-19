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
        <p>
            We express select fields by highlighting the columns. \n Here, 'column1' is selected and the parenthesis below the column name describes whether any
            aggregation function (e.g. min, max, avg, count, and sum) is applied to the column.
        </p>
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
const exampleEQVA: EVQATree = {
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

const headerInfo: PGResultFieldInterface[] = [{ name: "id", format: "number" }];
const data = [[1], [2], [3], [4], [5], [6], [7], [8], [9], [1], [1], [1]];
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
        <p>The following EVQA lists the number of customers in each country:</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const ProjectionSection: ITutorialSection = {
    title: "Select Fields",
    description:
        "The select field is an operation used to select data from a table.\nThrough projection, we can select columns of the table that we want to examine.\
        \nThe data returned is stored in a result table.",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default ProjectionSection;
