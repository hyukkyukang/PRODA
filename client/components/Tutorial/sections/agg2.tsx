import ITutorialSection from "./abstractSection";
import { CountAvgSumSyntaxExample } from "../syntaxExamples";

export const Agg2Section: ITutorialSection = {
    title: "Count, Avg, Sum",
    description:
        "The 'Count', 'Avg', and 'Sum' functions return the number of rows, the average of the selected column, and the sum of the selected column, respectively.",
    exampleQueryName: "countAvgSum",
    exampleDescription: "The following EVQL lists the number of car ids with the average maximum speed and the total price of cars",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [CountAvgSumSyntaxExample],
    syntaxDescription: "Below EVQL applies 'count', 'avg', 'sum' functions on 'column1', 'column2', and 'column3' respectively.",
};

export default Agg2Section;
