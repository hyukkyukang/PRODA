import ITutorialSection from "./abstractSection";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Nesting Syntax</h2>
            <p>
                "To use selection results on another selection, we first write an EVQL with selection. And with the second EVQL, we use the variable name of the
                first EVQL on the condition expression.",
            </p>
        </>
    );
};

export const NestingSection: ITutorialSection = {
    title: "Nesting",
    description: "EVQL allows you to use selection results for another selection",
    exampleQueryName: "nested",
    exampleDescription:
        "In the below example, we first find the average max_speed of models in the year 2010.\
                        \nThen, we find all models that has higher max_speed than the average max_speed of models in the year 2010.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [],
    syntaxDescription: SyntaxDescription(),
};

export default NestingSection;
