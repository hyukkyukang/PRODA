import ITutorialSection from "./abstractSection";
import { SelectionOrSyntaxExample, SelectionAndSyntaxExample } from "../syntaxExamples";

export const Selection2Section: ITutorialSection = {
    "title": "And, Or",
    "description": "With EVQL, we can apply multiple conditions with OR or AND operators",
    "exampleQueryName": "andOr",
    "exampleDescription": "The following EVQL applies conditons on column 'model' and 'year'.\nIt returns records that has model equal to 'tesla model x' and year is equal to 2011 or 2012",
    "demoDBName": "Overwrite a demo database name here",
    "syntaxExamples": [SelectionOrSyntaxExample, SelectionAndSyntaxExample],
    "syntaxDescription": "To combine conditions with OR, write conditions in a separate row.\n To combine conditions with AND, write conditions in the same row."
};

export default Selection2Section;
