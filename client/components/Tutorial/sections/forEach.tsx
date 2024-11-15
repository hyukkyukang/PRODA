import React from "react";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <React.Fragment>
        <h2>Expression</h2>
        <p>"Two successive EVQA queries are utilized to apply selection criteria to individual values within a column."</p>
    </React.Fragment>
);

const exampleDescription: JSX.Element = (
    <React.Fragment>
        <p>
            "In the following example, the first EVQA calculates the mean of the 'max_speed' column grouped by 'model'. Then with the second EVQA, we employ a
            selection criterion to compare the new 'model' column with the resultant 'model' column for each condition. Therefore, the second EVQA query filters
            models where the 'max_speed' value is higher than the average 'max_speed' of cars with identical 'model' values.",
        </p>
    </React.Fragment>
);

export const ForEachSection: ITutorialSection = {
    title: "ForEach",
    description: "EVQA allows you to add selection condition between a calculated results and each of the column values in a table",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default ForEachSection;
