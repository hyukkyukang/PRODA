import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLTable";
import { GroupingSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Grouping syntax</h2>
            <p>
                'The name of grouping function is "Group". We write grouping expression in the condition of the grouping column, with the name of the column
                given as an input to the grouping function.',
            </p>
            <Spreadsheet
                className="syntaxExample"
                data={GroupingSyntaxExample.rows}
                columnLabels={GroupingSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
        </>
    );
};

export const GroupingSection: ITutorialSection = {
    title: "Grouping",
    description:
        'The Grouping operation groups rows that have the same values into summary rows, like "find the number of customers in each country".\
                \nThe Grouping operation is often used with aggregate functions (e.g. min, max, avg, count, and sum) to group the result-set by one or more columns.',
    exampleQueryName: "groupBy",
    exampleDescription: " The following EVQL Groups data by the column 'model' and projects the name and number of models.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [GroupingSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default GroupingSection;
