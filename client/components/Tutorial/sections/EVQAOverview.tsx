import Image from "next/image";
import evqaStructureExample1 from "../../../public/images/evqaStructureExample1.png";
import evqaStructureExample2 from "../../../public/images/evqaStructureExample2.png";
import evqaStructureExample3 from "../../../public/images/evqaStructureExample3.png";
import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import React from "react";
import { Typography } from "@mui/material";

const operationFlowExample: JSX.Element = <React.Fragment></React.Fragment>;

const structureExample: JSX.Element = (
    <React.Fragment>
        <h1>Basic Structure</h1>
        <div style={{ width: 600 }}>
            <span>
                {
                    'EVQA is a spreadsheet like representation that describes an operation on a tabular data.\
        \nBelow is an image that shows the basic structure of EVQA on an input table named "cars" with columns: [id, model, horsepower, max_speed, year, price].'
                }
            </span>
        </div>
        <br />
        <br />
        <Image src={evqaStructureExample1} alt="EVQA Structure Example 1" height="75" width="600" />
        <br />
        <br />
        <div style={{ width: 600 }}>
            <span>
                {
                    "The name of the input table is written in the first header of EVQA. Any operation written below the first header means that it is performed on the whole table.\n"
                }
            </span>
            <span>
                {
                    "The following headers of EVQA represents the columns in the input table. Conditions written below each header describes operation on the corresponding column."
                }
            </span>
        </div>
        <br />
        <br />
        <Image src={evqaStructureExample2} alt="EVQA Structure Example 2" height="220" width="600" />
        <br />
        <br />
        <h1>Example of EVQA</h1>
        <div style={{ width: 600 }}>
            <span>{'Below is a simple EVQA that performs operation on an input table "cars".'}</span>
        </div>
        <br />
        <Image src={evqaStructureExample3} alt="EVQA Structure Example 3" height="150" width="600" />
        <br />
        <br />
        <div style={{ width: 600 }}>
            <span>
                {
                    'As will further explained in the following tutorial sections, the highlight on the first and the third header ("cars" and "model" respectively) illustates that the output of EVQA operation will show information about these two fields. '
                }
            </span>
            <span>{'The expression "Group($model)" below the column "model" means that the output data will be grouped by the column "model". '}</span>
            <span>
                {
                    'And the parenthesis "(count)" written below the first header means that it will count the number of data after they are grouped by the column "model". '
                }
            </span>
            <span>{"More details will be explained in the following tutorial sections."}</span>
            <br />
        </div>
        <br />
    </React.Fragment>
);

const description: JSX.Element = (
    <React.Fragment>
        {structureExample}
        <div style={{ whiteSpace: "pre-line" }}>{operationFlowExample}</div>
    </React.Fragment>
);

export const EVQAOverviewSection: ITutorialSection = {
    title: "EVQA Overview",
    description: "Write description here..",
    exampleDescription: <></>,
    syntaxDescription: <></>,
    itsOwnPage: description,
};

export default EVQAOverviewSection;
