import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLTable";
import { ProjectionSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Multiple Sublinks Syntax</h2>
            <p>Add syntax description here</p>
            <Spreadsheet
                className="syntaxExample"
                data={ProjectionSyntaxExample.rows}
                columnLabels={ProjectionSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
        </>
    );
};

export const MultipleSublinks: ITutorialSection = {
    title: "Multiple Sublinks",
    description: "Add description here",
    exampleQueryName: "multipleSublinks",
    exampleDescription: "Add example description here",
    demoDBName: "cars",
    syntaxExamples: [ProjectionSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default MultipleSublinks;
