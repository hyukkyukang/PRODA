import ITutorialSection from "./abstractSection";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>ForEach Syntax</h2>
        </>
    );
};

export const ForEachSection: ITutorialSection = {
    title: "ForEach",
    description: "Overwrite a description here",
    exampleQueryName: "correlatedNested",
    exampleDescription: "overwrite a description here",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [],
    syntaxDescription: SyntaxDescription(),
};

export default ForEachSection;
