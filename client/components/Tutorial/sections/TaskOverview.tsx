import { Typography } from "@mui/material";
import React from "react";
import ITutorialSection from "./abstractSection";
import Image from "next/image";
import dataCollectionSnapshot from "../../../public/images/dataCollectionSnapshot.png";
import dataCollectionCorrectExample from "../../../public/images/dataCollectionCorrectExample.png";
import dataCollectionIncorrectExample from "../../../public/images/dataCollectionIncorrectExample.png";

const correctNLExample: JSX.Element = (
    <React.Fragment>
        <h1>When the sentence is correct</h1>
        <Typography>When the given sentence is correct, the user has to rephrase the given sentence into a more natural sentence.</Typography>
        <Typography>When the user solves all the given tasks, the user will be redirected to the "Answer submitted" page as below.</Typography>
        <br />
        <Image src={dataCollectionCorrectExample} style={{ width: "1000px", height: "300px" }} alt="Task done Snapshot" />
    </React.Fragment>
);

const incorrectNLExample: JSX.Element = (
    <React.Fragment>
        <h1>When the sentence is incorrect</h1>
        <Typography>When the given sentence is incorrect, the user has to write a correct sentence that describes the EVQA operation.</Typography>
        <Typography> After writing the correct sentence, the user has to click on the "Submit" button.</Typography>
        <br />
        <Image src={dataCollectionIncorrectExample} style={{ width: "1000px", height: "300px" }} alt="Task done Snapshot" />
    </React.Fragment>
);

const mouseHoverDescription: JSX.Element = <></>;

const doneExample: JSX.Element = (
    <React.Fragment>
        <img src={"/taskDoneSnapshot.png"} style={{ width: "1000px", height: "500px" }} alt="Task done Snapshot" />
    </React.Fragment>
);

const description: JSX.Element = (
    <React.Fragment>
        <Typography>
            For each task, user has to understand the given EVQA and check if the sentence at the bottom of the page correctly describe the EVQA oepration
        </Typography>
        <br />
        <Image src={dataCollectionSnapshot} style={{ width: "1000px", height: "500px" }} alt="Data Collection Snapshot" />
        <br />
        <br />
        {correctNLExample}
        <br />
        {/* {mouseHoverDescription} */}
        <br />
        <br />
        {incorrectNLExample}
        {/* <br />
        {doneExample} */}
    </React.Fragment>
);

export const TaskOverviewSection: ITutorialSection = {
    title: "Task Overview",
    description: "Write description here..",
    exampleDescription: <></>,
    syntaxDescription: <></>,
    itsOwnPage: description,
};

export default TaskOverviewSection;
