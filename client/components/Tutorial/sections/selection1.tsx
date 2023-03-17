import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { SelectionSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Selection Syntax</h2>
            <p>We can write conditions below any columns to add conditions on those columns.</p>
            <Spreadsheet
                className="syntaxExample"
                data={SelectionSyntaxExample.rows}
                columnLabels={SelectionSyntaxExample.headers}
                ColumnIndicator={EVQAColumnIndicator}
            />
        </>
    );
};

export const Selection1Section: ITutorialSection = {
    title: "Selection",
    description: "EVQA Selection is used to filter records.\nIt is used to extract only those records that fufill a specified condition",
    exampleQueryName: "selection",
    exampleDescription: "The following EVQA the column id to project and applies condition on the column 'year'. It will return record of cars with year 2010.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [SelectionSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default Selection1Section;
