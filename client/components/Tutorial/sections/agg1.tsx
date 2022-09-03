import ITutorialSection from "./abstractSection";
import { MinMaxSyntaxExample } from "../syntaxExamples";

export const Agg1Section: ITutorialSection = {
    title: "Min and Max",
    description: "The 'Min' and 'Max' functions return the smallest and largest values of the selected column. respectively.",
    exampleQueryName: "minMax",
    exampleDescription: "The following EVQL lists the maximum 'horsepower' and the minimum 'max_speed' of cars",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [MinMaxSyntaxExample],
    syntaxDescription: "Below EVQL applies min function on 'column1' and max function on 'column2'.",
};

export default Agg1Section;
