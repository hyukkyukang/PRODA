import ITutorialSection from "./abstractSection";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Selection on Aggregated Results Syntax</h2>
            <p>
                To perform selection on aggregated results, we first write an EVQA with grouping operation. And we write another EVQA with a condition on the
                result of the first EVQA query.
            </p>
        </>
    );
};

export const Selection3Section: ITutorialSection = {
    title: "Selection on Aggregated Results",
    description: "EVQA allows you to add selection on aggregated results",
    exampleQueryName: "having",
    exampleDescription:
        "In the below example, we first group models and find the average max_speed of each model.\
                        \nThen, we show the name of models with average max_speed greater than 400.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [],
    syntaxDescription: SyntaxDescription(),
};

export default Selection3Section;

// The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.
