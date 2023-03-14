import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLColumnIndicator";
import { SelectionOrSyntaxExample, SelectionAndSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>AND Syntax</h2>
            <p>To combine conditions with OR, write conditions in a separate row.</p>
            <Spreadsheet
                className="syntaxExample"
                data={SelectionOrSyntaxExample.rows}
                columnLabels={SelectionOrSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
            <h2>Or Syntax</h2>
            <p>
                To combine conditions with AND, write conditions in the same row. To write a multiple conditions for one column, use the keyword AND to combine
                two different expressions.
            </p>
            <Spreadsheet
                className="syntaxExample"
                data={SelectionAndSyntaxExample.rows}
                columnLabels={SelectionAndSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
        </>
    );
};

export const Selection2Section: ITutorialSection = {
    title: "And, Or",
    description: "With EVQL, we can apply multiple conditions with OR or AND operators",
    exampleQueryName: "andOr",
    exampleDescription:
        "The following EVQL applies conditons on column 'model' and 'year'.\nIt returns records that has model equal to 'tesla model x' and year is equal to 2011 or 2012",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [SelectionOrSyntaxExample, SelectionAndSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default Selection2Section;
