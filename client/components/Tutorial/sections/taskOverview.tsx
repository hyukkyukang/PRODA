import { Typography } from "@mui/material";
import Image from "next/image";
import React from "react";
import dataCollectionCorrectExample from "../../../public/images/dataCollectionCorrectExample.png";
import dataCollectionIncorrectExample from "../../../public/images/dataCollectionIncorrectExample.png";
import dataCollectionSnapshot from "../../../public/images/dataCollectionSnapshot.png";
import hoveringExample from "../../../public/images/hoveringExample.png";
import ITutorialSection from "./abstractSection";
import EVQABlockExample from "../../../public/images/EVQABlockExample.png";
import answerSheet from "../../../public/images/answerSheet.png";

const overview: JSX.Element = (
    <React.Fragment>
        <h1> Introduction </h1>
        <Typography>
            <b>The task you need to perform is to understand the provided EVQA block, verify its natural language description, and then submit it after rephrasing.</b>
            This page provides an overview of our task, which aims to assess users' ability to understand Excel-like Visual Query Abstraction (EVQA) and verify
            whether the final sentence accurately describes its operation. We will now explain the structure of our data collection page and how the task is
            performed. As shown in the below snapshot, the page is divided into three sections: instructions at the top, the EVQA block in the center, and the
            answering sheet at the bottom. The EVQA block is the primary component of the task and is represented by a green block in the center. Initially, the
            EVQA block is folded and users need to click to expand it to see the EVQA operation.
        </Typography>
        <br />
        <Image src={dataCollectionSnapshot} style={{ width: "1000px", height: "600px" }} alt="Data collection snapshot" />
    </React.Fragment>
);

const EVQABlockDescription: JSX.Element = (
    <React.Fragment>
        <h1>EVQA Block</h1>
        <Typography>
            Here we explain how each EVQA block is structured. As shown in the below snapshot, EVQA block is consisted of the input table, EVQA, result table,
            and a sentence that describes the EVQA operation. Detailed explanation of how to understand EVQA will be covered in the following tutorial section.
            Note that the goal of each user is to fully understand the EVQA operation and check whether the given sentence accurately describes the EVQA.
        </Typography>
        <Image src={EVQABlockExample} style={{ width: "1000px", height: "900px" }} alt="Collection page layout example" />
    </React.Fragment>
);

const mouseHoverDescription: JSX.Element = (
    <React.Fragment>
        <h1>Hovering over EVQA Cells</h1>
        To assist users in understanding the EVQA operation, we provide a feature that allows users to hover over the EVQA cells to see the description of the
        operators used in each cell. As shown in the below snapshot, when the user hovers over the EVQA cell, the description of the operator is shown beside
        the cursor.
        <Image src={hoveringExample} style={{ width: "1000px", height: "250px" }} alt="Mouse hover snapshot" />
    </React.Fragment>
);

const correctNLExample: JSX.Element = (
    <React.Fragment>
        <h2>When the sentence is correct</h2>
        <Typography>When the given sentence is correct, the user has to rephrase the given sentence into a more natural sentence.</Typography>
        <Typography>After writing the correct sentence, the user has to click on the "Submit" button.</Typography>
        <Image src={dataCollectionCorrectExample} style={{ width: "1000px", height: "400px" }} alt="Task done snapshot" />
    </React.Fragment>
);

const incorrectNLExample: JSX.Element = (
    <React.Fragment>
        <h2>When the sentence is incorrect</h2>
        <Typography>When the given sentence is incorrect, the user has to write a correct sentence that describes the EVQA operation.</Typography>
        <Typography>After writing the correct sentence, the user has to click on the "Submit" button.</Typography>
        <Image src={dataCollectionIncorrectExample} style={{ width: "1000px", height: "430px" }} alt="Task done snapshot" />
    </React.Fragment>
);

const answerSheetDescription: JSX.Element = (
    <React.Fragment>
        <h1>Answer sheet</h1>
        <Typography>
            The following is a preview of the response sheet that users will initially view, prior to selecting whether the sentence is correct or not.
        </Typography>
        <Image src={answerSheet} alt="Answer sheet snapshot" style={{ width: "1000px", height: "200px" }} />
        <br />
        <br />
        {correctNLExample}
        <br />
        <br />
        {incorrectNLExample}
    </React.Fragment>
);

const description: JSX.Element = (
    <div style={{ width: 1000 }}>
        {overview}
        <br />
        <br />
        <br />
        {EVQABlockDescription}
        <br />
        <br />
        {mouseHoverDescription}
        <br />
        <br />
        {answerSheetDescription}
    </div>
);

export const TaskOverviewSection: ITutorialSection = {
    title: "Task Overview",
    description: "Write description here..",
    exampleDescription: <></>,
    syntaxDescription: <></>,
    itsOwnPage: description,
};

export default TaskOverviewSection;
