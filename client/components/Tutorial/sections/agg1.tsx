import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import { MinMaxSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Min and Max Syntax</h2>
            <p>"Below EVQA applies min function on 'column1' and max function on 'column2'."</p>
            <Spreadsheet
                className="syntaxExample"
                data={MinMaxSyntaxExample.rows}
                columnLabels={MinMaxSyntaxExample.headers}
                ColumnIndicator={EVQAColumnIndicator}
            />
        </>
    );
};

export const Agg1Section: ITutorialSection = {
    title: "Min and Max",
    description: "The 'Min' and 'Max' functions return the smallest and largest values of the selected column. respectively.",
    exampleQueryName: "minMax",
    exampleDescription: "The following EVQA lists the maximum 'horsepower' and the minimum 'max_speed' of cars",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [MinMaxSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default Agg1Section;
