import ITutorialSection from "./abstractSection";
import { ProjectionSyntaxExample } from "../syntaxExamples";

export const ProjectionSection: ITutorialSection = {
    title: "Projection",
    description:
        "The Projection operation is used to select data from a database.\nThrough projection, we can select columns of the table that we want to examine.\
        \nThe data returned is stored in a result table.",
    exampleQueryName: "projection",
    exampleDescription: "The following EVQL lists the number of customers in each country:",
    demoDBName: "cars",
    syntaxExamples: [ProjectionSyntaxExample],
    syntaxDescription: `We express projection by highlighting the columns that we want to project. \n Here, 'column1' is the field name of the table we want to select data from. \n The annotation inside the parenthesis describes whether any aggregation function (e.g. min, max, avg, count, and sum) is applied to the column.`,
};

export default ProjectionSection;
