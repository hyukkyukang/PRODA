import Spreadsheet from "react-spreadsheet-custom";

import ITutorialSection from "./abstractSection";
import { EVQAColumnIndicator } from "../../VQA/EVQAColumnIndicator";
import React from "react";
import { Typography } from "@mui/material";

const operationFlowExample: JSX.Element = <React.Fragment>operation</React.Fragment>;

const structureExample: JSX.Element = <React.Fragment></React.Fragment>;

const description: JSX.Element = (
    <React.Fragment>
        {structureExample}
        <br />
        {operationFlowExample}
    </React.Fragment>
);

export const EVQAOverviewSection: ITutorialSection = {
    title: "EVQA Overview",
    description: "Write description here..",
    exampleQueryName: "overview",
    exampleDescription: "Write description here..",
    demoDBName: "Overwrite a demo database name here",
    syntaxExamples: [],
    syntaxDescription: <></>,
    itsOwnPage: description,
};

export default EVQAOverviewSection;
