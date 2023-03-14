import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLColumnIndicator";
import { ProjectionSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Projection Syntax</h2>
            <p>
                We express projection by highlighting the columns to project. \n Here, 'column1' is selected and the parenthesis below the column name describes
                whether any aggregation function (e.g. min, max, avg, count, and sum) is applied to the column.
            </p>
            <Spreadsheet
                className="syntaxExample"
                data={ProjectionSyntaxExample.rows}
                columnLabels={ProjectionSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
        </>
    );
};

export const ProjectionSection: ITutorialSection = {
    title: "Projection",
    description:
        "The Projection operation is used to select data from a database.\nThrough projection, we can select columns of the table that we want to examine.\
        \nThe data returned is stored in a result table.",
    exampleQueryName: "projection",
    exampleDescription: "The following EVQL lists the number of customers in each country:",
    demoDBName: "cars",
    syntaxExamples: [ProjectionSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default ProjectionSection;
