import ITutorialSection from "./abstractSection";
import { GroupingSyntaxExample } from "../syntaxExamples";

export const GroupingSection: ITutorialSection = {
    title: "Grouping",
    description:
        'The Grouping operation groups rows that have the same values into summary rows, like "find the number of customers in each country".\
                \nThe Grouping operation is often used with aggregate functions (e.g. min, max, avg, count, and sum) to group the result-set by one or more columns.',
    exampleQueryName: "groupBy",
    exampleDescription: " The following EVQL Groups data by the column 'model' and projects the name and number of models.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [GroupingSyntaxExample],
    syntaxDescription:
        'The name of grouping function is "Group". \
        \n We write grouping expression in the condition of the grouping column, with the name of the column given as an input to the grouping function.',
};

export default GroupingSection;
