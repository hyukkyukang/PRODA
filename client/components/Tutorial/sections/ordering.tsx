import React from "react";
import Spreadsheet from "react-spreadsheet-custom";
import { PGResultFieldInterface, PGResultInterface, PGResultToTableExcerpt } from "../../TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../../TableExcerpt/TableExcerpt";
import { aggFunctions, binaryOperators, EVQATree } from "../../VQA/EVQA";
import { dataViewer } from "../../VQA/EVQACell";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { EVQATables } from "../../VQA/EVQATable";
import { demoTable } from "../examples/demoTable";
import { OrderingAscSyntaxExample, OrderingDescSyntaxExample } from "../examples/EVQAExamples";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>{'Below EVQA uses sorting operation on "column1". The arrow pointing up indicates that it is sorting in ascending order'}</p>
        <Spreadsheet
            className="syntaxExample"
            data={OrderingAscSyntaxExample.rows}
            columnLabels={OrderingAscSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
            DataViewer={dataViewer}
        />
        <br />
        <br />
        <p>{'Below EVQA uses sorting operation on "column1". The arrow pointing down indicates that it is sorting in descending order'}</p>
        <Spreadsheet
            className="syntaxExample"
            data={OrderingDescSyntaxExample.rows}
            columnLabels={OrderingDescSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
            DataViewer={dataViewer}
        />
    </>
);

// Demo EVQA and results
const headers = ["cars"].concat(demoTable.headers);
// const exampleEQVA: EVQATree = {
//     node: {
//         name: "select",
//         table_excerpt: demoTable,
//         headers: headers,
//         projection: {
//             headers: [{ id: headers.indexOf("id"), agg_type: aggFunctions.indexOf("none") }],
//         },
//         predicate: {
//             clauses: [
//                 {
//                     conditions: [
//                         { header_id: headers.indexOf("year"), func_type: "Selecting", op_type: binaryOperators.indexOf("=") + 1, r_operand: "2010" },
//                         { header_id: headers.indexOf("horsepower"), func_type: "Ordering", is_ascending: false },
//                     ],
//                 },
//             ],
//         },
//     },
//     children: [],
// };
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
        <TableExcerpt queryResult={demoTable} />
        <p>The following EVQA selectes id of cars which are manufactured in year 2010. It should the result in the descending order of horsepower.</p>
        <EVQATables evqaRoot={exampleEQVA} editable={false} />
        <h2>Result:</h2>
        <TableExcerpt queryResult={exampleResult} />
    </React.Fragment>
);

export const OrderingSection: ITutorialSection = {
    title: "Sorting",
    description: `EVQA can use sorting operations to sort the result-set in ascending or descending order.\n`,
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default OrderingSection;
