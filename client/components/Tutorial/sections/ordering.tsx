import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { OrderingAscSyntaxExample, OrderingDescSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>"Asc" and "Desc" are the two functions used to specify the order of the result-set.</p>
        <Spreadsheet
            className="syntaxExample"
            data={OrderingAscSyntaxExample.rows}
            columnLabels={OrderingAscSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
        <br />
        <br />
        <Spreadsheet
            className="syntaxExample"
            data={OrderingDescSyntaxExample.rows}
            columnLabels={OrderingDescSyntaxExample.headers}
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
                {
                    conditions: [
                        { header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2010" },
                        { header_id: headers.indexOf("horsepower"), func_type: "Ordering", is_ascending: false },
                    ],
                },
            ],
        },
    },
    children: [],
};
const headerInfo: PGResultFieldInterface[] = [{ name: "id", format: "number" }];

const data = [[2], [1]];
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
        <p>The following EVQA projects id of cars which are manufactured in year 2010 by descending order of horsepower.</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const OrderingSection: ITutorialSection = {
    title: "Sorting",
    description: "Sorting operation is used to sort the result-set in ascending or descending order.",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default OrderingSection;
