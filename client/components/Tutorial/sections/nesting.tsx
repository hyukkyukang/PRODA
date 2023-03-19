import React from "react";
import ITutorialSection from "./abstractSection";

export const SyntaxDescription = (
    <>
        <h2>Expression</h2>
        <p>
            "To use selection results on another selection, we first write an EVQA with selection. And with the second EVQA, we use the variable name of the
            first EVQA on the condition expression.",
        </p>
    </>
);

const exampleDescription: JSX.Element = (
    <React.Fragment>
        <p>In the below example, we first find the average max_speed of models in the year 2010.</p>
        <p>Then, we find all models that has higher max_speed than the average max_speed of models in the year 2010.</p>
    </React.Fragment>
);

export const NestingSection: ITutorialSection = {
    title: "Nesting",
    description: "EVQA allows you to use selection results for another selection",
    exampleDescription: exampleDescription,
    syntaxDescription: SyntaxDescription,
};

export default NestingSection;
