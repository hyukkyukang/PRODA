import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLTable";
import { CountAvgSumSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Count, Avg, Sum Syntax</h2>
            <p>Below EVQL applies 'count', 'avg', 'sum' functions on 'column1', 'column2', and 'column3' respectively.</p>
            <Spreadsheet
                className="syntaxExample"
                data={CountAvgSumSyntaxExample.rows}
                columnLabels={CountAvgSumSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
        </>
    );
};

export const Agg2Section: ITutorialSection = {
    title: "Count, Avg, Sum",
    description:
        "The 'Count', 'Avg', and 'Sum' functions return the number of rows, the average of the selected column, and the sum of the selected column, respectively.",
    exampleQueryName: "countAvgSum",
    exampleDescription: "The following EVQL lists the number of car ids with the average maximum speed and the total price of cars",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [CountAvgSumSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default Agg2Section;
