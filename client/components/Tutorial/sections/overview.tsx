import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Overview</h2>
            {/* <Spreadsheet
                className="syntaxExample"
                data={MinMaxSyntaxExample.rows}
                columnLabels={MinMaxSyntaxExample.headers}
                ColumnIndicator={EVQAColumnIndicator}
            /> */}
        </>
    );
};

export const OverviewSection: ITutorialSection = {
    title: "Min and Max",
    description: "The 'Min' and 'Max' functions return the smallest and largest values of the selected column. respectively.",
    exampleQueryName: "minMax",
    exampleDescription: "The following EVQA lists the maximum 'horsepower' and the minimum 'max_speed' of cars",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [],
    syntaxDescription: SyntaxDescription(),
};

export default OverviewSection;
