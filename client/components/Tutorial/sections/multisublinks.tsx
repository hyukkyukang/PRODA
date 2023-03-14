import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLColumnIndicator";
import { ProjectionSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Multiple Sublinks Syntax</h2>
            <p>To perform multiple sublinks, we use multiple EVQL queries</p>
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
    description: "EVQL allows you to use mulitple selection results for another selection",
    exampleQueryName: "multipleSublinks",
    exampleDescription:
        "In the following example, we use two EVQA queries to select average horsepower of model genesis and average max_speed of model hyundai. Then we use the results of these two queries to select cars with horsepower higher than average horsepower of genesis and max_speed higher than average max_speed of hyundai.",
    demoDBName: "cars",
    syntaxExamples: [ProjectionSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default MultipleSublinks;
