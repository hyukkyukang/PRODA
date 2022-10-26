import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQLColumnIndicator } from "../../VQL/EVQLTable";
import { OrderingSyntaxExample } from "../syntaxExamples";

export const SyntaxDescription = () => {
    return (
        <>
            <h2>Ordering Syntax</h2>
            <p>"Asc" and "Desc" are the two functions used to specify the order of the result-set.</p>
            <Spreadsheet
                className="syntaxExample"
                data={OrderingSyntaxExample.rows}
                columnLabels={OrderingSyntaxExample.headers}
                ColumnIndicator={EVQLColumnIndicator}
            />
        </>
    );
};

export const OrderingSection: ITutorialSection = {
    title: "Ordering",
    description: "Ordering operation is used to sort the result-set in ascending or descending order.",
    exampleQueryName: "orderBy",
    exampleDescription: "The following EVQL projects id of cars which are manufactured in year 2010 by descending order of horsepower.",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [OrderingSyntaxExample],
    syntaxDescription: SyntaxDescription(),
};

export default OrderingSection;
