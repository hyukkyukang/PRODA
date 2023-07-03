import { Typography } from "@mui/material";
import Image from "next/image";
import React from "react";
import ITutorialSection from "./abstractSection";

import block1EVQABlock1_1 from "../../../public/images/example2/block1/EVQABlock1_1.png";
import block1EVQABlock1_2_correct from "../../../public/images/example2/block1/EVQABlock1_2_correct.png";
import block1EVQABlock1_2_incorrect from "../../../public/images/example2/block1/EVQABlock1_2_incorrect.png";
import block1CorrectAnswer from "../../../public/images/example2/block1/correctAnswer.png";
import block1IncorrectAnswer from "../../../public/images/example2/block1/incorrectAnswer.png";

import block2EVQABlock from "../../../public/images/example2/block2/EVQABlock2.png";
import block2Answer from "../../../public/images/example2/block2/answer.png";

const introduction: JSX.Element = (
    <React.Fragment>
        <h1> Advanced Task Example </h1>
        <Typography>Here we provide two advanced examples where you must check two EVQA blocks.</Typography>
    </React.Fragment>
);

const correctBlock1Example: JSX.Element = (
    <React.Fragment>
        <h2>Block1</h2>
        <Typography>Here is the first EVQA Block where the given question in English correctly describes the EVQA Block.</Typography>
        <Image src={block1EVQABlock1_1} alt="EVQA Block" style={{ width: "1000px", height: "1100px" }} />
        <Image src={block1EVQABlock1_2_correct} alt="EVQA Block" style={{ width: "1000px", height: "150px" }} />
        <br />
        <br />
        <Typography>Because the given question in English is correct, we mark "Is correct" and paraphrase the sentence.</Typography>
        <Image src={block1CorrectAnswer} alt="EVQA Block" style={{ width: "1000px", height: "400px" }} />
        <br />
    </React.Fragment>
);

const incorrectBlock1Example: JSX.Element = (
    <React.Fragment>
        <h2>Block1</h2>
        <Typography>Here is another case of the first EVQA Block where given question in English does not correctly describes the EVQA Block.</Typography>
        <Image src={block1EVQABlock1_1} alt="EVQA Block" style={{ width: "1000px", height: "1100px" }} />
        <Image src={block1EVQABlock1_2_incorrect} alt="EVQA Block" style={{ width: "1000px", height: "150px" }} />
        <br />
        <br />
        <Typography>
            To correctly describe the EVQA, the sentence should say "or" instead of "and". Because the sentence is wrong (i.e., case 1), we mark "Is not
            correct" and modify the sentence.
        </Typography>
        <Image src={block1IncorrectAnswer} alt="EVQA Block" style={{ width: "1000px", height: "400px" }} />
        <br />
    </React.Fragment>
);

const block2Example: JSX.Element = (
    <React.Fragment>
        <h2>Block2</h2>
        <Typography>The second block performs operation over the result of the first block</Typography>
        <Image src={block2EVQABlock} alt="EVQA Block" style={{ width: "1000px", height: "850px" }} />
        <br />
        <br />
        <Typography>
            Because the given question in English has direct reference to preceding EVQA block unpacked (i.e., case 4), we mark "Is not correct" and modify the
            sentence.
        </Typography>
        <Image src={block2Answer} alt="EVQA Block" style={{ width: "1000px", height: "400px" }} />
        <br />
    </React.Fragment>
);

const example1: JSX.Element = (
    <React.Fragment>
        <h1>Example 1</h1>
        {correctBlock1Example}
        <br />
        {block2Example}
    </React.Fragment>
);

const example2: JSX.Element = (
    <React.Fragment>
        <h1>Example 2</h1>
        {incorrectBlock1Example}
        <br />
        {block2Example}
    </React.Fragment>
);
const description: JSX.Element = (
    <div style={{ width: 1000 }}>
        {introduction}
        <br />
        <br />
        {example1}
        <br />
        {example2}
    </div>
);

export const TaskExampleAdvancedSection: ITutorialSection = {
    title: "Advanced Task Example",
    description: "Write description here..",
    exampleDescription: <></>,
    syntaxDescription: <></>,
    itsOwnPage: description,
};

export default TaskExampleAdvancedSection;
