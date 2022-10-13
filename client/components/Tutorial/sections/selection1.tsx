import ITutorialSection from "./abstractSection";
import { SelectionSyntaxExample } from "../syntaxExamples";

export const Selection1Section: ITutorialSection = {
    title: "Selection",
    description: "EVQL Selection is used to filter records.\nIt is used to extract only those records that fufill a specified condition",
    exampleQueryName: "selection",
    exampleDescription: "The following EVQL the column id to project and applies condition on the column 'year'. It will return record of cars with year 2010.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [SelectionSyntaxExample],
    syntaxDescription: "We can write conditions below any columns to add conditions on those columns.",
};

export default Selection1Section;
