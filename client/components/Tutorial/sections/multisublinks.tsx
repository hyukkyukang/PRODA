import React from "react";
import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { ProjectionSyntaxExample } from "../examples/EVQAExamples";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>To perform multiple sublinks, we use multiple EVQA queries</p>
        <Spreadsheet
            className="syntaxExample"
            data={ProjectionSyntaxExample.rows}
            columnLabels={ProjectionSyntaxExample.headers}
            ColumnIndicator={EVQAColumnIndicator}
        />
    </>
);

const exampleDescription: JSX.Element = (
    <React.Fragment>
        <p>
            In the following example, we use two EVQA queries to select average horsepower of model genesis and average max_speed of model hyundai. Then we use
            the results of these two queries to select cars with horsepower higher than average horsepower of genesis and max_speed higher than average
            max_speed of hyundai.
        </p>
    </React.Fragment>
);

export const MultipleSublinks: ITutorialSection = {
    title: "Multiple Sublinks",
    description: "EVQA allows you to use mulitple selection results for another selection",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default MultipleSublinks;
