import { Typography } from "@mui/material";
import Image from "next/image";
import React from "react";
import ITutorialSection from "./abstractSection";
import correctEVQABlockExample from "../../../public/images/example1/correctVersion/EVQABlock.png";
import correctAnswerExample from "../../../public/images/example1/correctVersion/answer.png";
import incorrectEVQABlockExample from "../../../public/images/example1/incorrectVersion/EVQABlock.png";
import incorrectAnswerExample from "../../../public/images/example1/incorrectVersion/answer.png";

const introduction: JSX.Element = (
    <React.Fragment>
        <h1> Task Example </h1>
        <Typography>Here we provide two examples for the task</Typography>
    </React.Fragment>
);

const correctExample: JSX.Element = (
    <React.Fragment>
        <h1>Example1: where the provided question in English is correct</h1>
        <Typography>Here is the given question in English correctly describes the EVQA Block below.</Typography>
        <Image src={correctEVQABlockExample} alt="EVQA Block" style={{ width: "1000px", height: "1100px" }} />
        <br />
        <br />
        <Typography>Because the given question in English is correct, we mark "Is correct" and paraphrase the sentence</Typography>
        <Image src={correctAnswerExample} alt="EVQA Block" style={{ width: "1000px", height: "400px" }} />
        <br />
    </React.Fragment>
);

const incorrectExample: JSX.Element = (
    <React.Fragment>
        <h1>Example2: where the provided question in English is incorrect</h1>
        <Typography>Here is the given question in English does not correctly describes the EVQA Block below.</Typography>
        <Image src={incorrectEVQABlockExample} alt="EVQA Block" style={{ width: "1000px", height: "1100px" }} />
        <br />
        <br />
        <Typography>Because the given question in English has missing information (i.e., case 3), we mark "Is not correct" and modify the sentence</Typography>
        <Image src={incorrectAnswerExample} alt="EVQA Block" style={{ width: "1000px", height: "400px" }} />
        <br />
    </React.Fragment>
);

const description: JSX.Element = (
    <div style={{ width: 1000 }}>
        {introduction}
        <br />
        {correctExample}
        <br />
        <br />
        {incorrectExample}
    </div>
);

export const TaskExampleSimpleSection: ITutorialSection = {
    title: "Simple Task Example",
    description: "Write description here..",
    exampleDescription: <></>,
    syntaxDescription: <></>,
    itsOwnPage: description,
};

export default TaskExampleSimpleSection;
