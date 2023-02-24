import ContentPasteGoIcon from "@mui/icons-material/ContentPasteGo";
import { Button, createTheme, FormGroup, Input, Paper, ThemeProvider, Typography } from "@mui/material";
import Checkbox from "@mui/material/Checkbox";
import { pink } from "@mui/material/colors";
import { Icon, SvgIcon } from "@mui/material";
import React, { useEffect } from "react";
import { TaskTypes } from "./instruction";

export interface UserAnswer {
    type: TaskTypes;
    nl: string;
    isCorrect?: boolean;
}

export interface AnswerSheetProps {
    taskType: TaskTypes | undefined;
    taskNL: string | undefined;
    answer: UserAnswer;
    setAnswer: React.Dispatch<React.SetStateAction<UserAnswer>>;
    onSubmitHandler: () => void;
}

const theme = createTheme({
    components: {
        MuiSwitch: {
            styleOverrides: {
                switchBase: {
                    // Controls default (unchecked) color for the thumb
                    color: "red",
                },
                colorPrimary: {
                    "&.Mui-checked": {
                        // Controls checked color for the thumb
                        color: "green",
                    },
                },
                track: {
                    // Controls default (unchecked) color for the track
                    opacity: 0.5,
                    backgroundColor: "red",
                    ".Mui-checked.Mui-checked + &": {
                        // Controls checked color for the track
                        opacity: 0.5,
                        backgroundColor: "green",
                    },
                },
            },
        },
    },
});

export const YesNoAnswerSheet = (props: {
    answer: UserAnswer;
    setAnswer: React.Dispatch<React.SetStateAction<UserAnswer>>;
    taskNL: string;
    onSubmitHandler: () => void;
}) => {
    const { answer, setAnswer, taskNL, onSubmitHandler } = props;
    const [yesIsChecked, setYesIsChecked] = React.useState<boolean>(false);
    const [noIsChecked, setNoIsChecked] = React.useState<boolean>(false);

    const handleIsYesClicked = (event: React.ChangeEvent<HTMLInputElement>) => {
        setYesIsChecked(event.target.checked);
        if (event.target.checked) {
            setNoIsChecked(false);
        }
        setAnswer({ ...answer, isCorrect: event.target.checked });
    };
    const handleIsNoClicked = (event: React.ChangeEvent<HTMLInputElement>) => {
        setNoIsChecked(event.target.checked);
        if (event.target.checked) {
            setYesIsChecked(false);
        }
        setAnswer({ ...answer, isCorrect: !event.target.checked });
    };

    const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
        setAnswer({ ...answer, nl: event.target.value });
    };

    const pasteClickHandler = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        setAnswer({ ...answer, nl: taskNL });
    };

    const submitButton = (
        <Button size="small" variant="contained" color="success" onClick={onSubmitHandler}>
            Submit
        </Button>
    );

    useEffect(() => {
        setAnswer({ ...answer, type: TaskTypes.NLAugmentation });
    }, []);

    const yesNoButtons = (
        <ThemeProvider theme={theme}>
            <FormGroup>
                <div style={{ display: "inline", paddingLeft: "10px" }}>
                    <div style={{ display: "inline-block" }}>
                        Is correct
                        <Checkbox color="success" checked={yesIsChecked} onChange={handleIsYesClicked} />
                    </div>
                    <div style={{ display: "inline-block", paddingLeft: "10px" }}>
                        Is not correct
                        <Checkbox sx={{ color: pink[600], "&.Mui-checked": { color: pink[600] } }} checked={noIsChecked} onChange={handleIsNoClicked} />
                    </div>
                    {yesIsChecked ? <div style={{ display: "inline-block", paddingLeft: "10px" }}>{submitButton}</div> : null}
                </div>
            </FormGroup>
        </ThemeProvider>
    );
    return (
        <React.Fragment>
            <Paper elevation={2} style={{ height: "45px", overflowX: "scroll" }}>
                <div style={{ marginLeft: "10px" }}>
                    <div>
                        <div style={{ display: "inline-block" }}>
                            <Typography sx={{ paddingTop: "10px" }}>Does the given sentence correctly describe the given query?</Typography>
                        </div>
                        <div style={{ display: "inline-block" }}>
                            <div style={{ marginLeft: "10px" }}>{yesNoButtons}</div>
                        </div>
                    </div>
                </div>
            </Paper>
            <br />
            {noIsChecked ? (
                <>
                    <Paper elevation={2} style={{ height: "55px", overflowX: "scroll" }}>
                        <div style={{ marginLeft: "10px" }}>
                            <div style={{ display: "inline-block" }}>
                                <Typography sx={{ paddingTop: "10px" }}>Please type the correct sentence:</Typography>
                            </div>
                            <div style={{ display: "inline-block", paddingLeft: "10px", width: "500px" }}>
                                <Input value={answer.nl} placeholder="Type your answer here" sx={{ width: "100%" }} onChange={inputHandler} />
                            </div>
                            <div style={{ display: "inline-block" }}>
                                <button style={{ marginTop: "5px", fontSize: 1 }} onClick={pasteClickHandler}>
                                    <ContentPasteGoIcon />
                                </button>
                            </div>
                            {answer.nl ? <div style={{ display: "inline-block", paddingLeft: "10px" }}>{submitButton}</div> : null}
                        </div>
                    </Paper>
                    <br />
                </>
            ) : null}
        </React.Fragment>
    );
};

export const AugmentationAnswerSheet = (props: { answer: UserAnswer; setAnswer: React.Dispatch<React.SetStateAction<UserAnswer>> }) => {
    const { answer, setAnswer } = props;

    const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
        setAnswer({ ...answer, nl: event.target.value });
    };

    useEffect(() => {
        setAnswer({ ...answer, type: TaskTypes.NLAugmentation });
    }, []);

    return (
        <React.Fragment>
            <Paper elevation={2}>
                <div style={{ marginLeft: "10px" }}>
                    <Typography sx={{ paddingTop: "10px" }} variant="h6">
                        Please rephrase the given sentence so that it correctly describes the query
                    </Typography>
                    <Input defaultValue={answer.nl} placeholder="Type rephrased natural language query" sx={{ width: "98%" }} onChange={inputHandler} />
                    <br />
                    <br />
                </div>
            </Paper>
        </React.Fragment>
    );
};

export const AnswerSheet = (props: AnswerSheetProps) => {
    const { taskType, taskNL, answer, setAnswer, onSubmitHandler } = props;
    if (taskType === TaskTypes.YesNo) {
        return <YesNoAnswerSheet answer={answer} setAnswer={setAnswer} taskNL={taskNL ? taskNL : ""} onSubmitHandler={onSubmitHandler} />;
    } else if (taskType === TaskTypes.NLAugmentation) {
        return <AugmentationAnswerSheet answer={answer} setAnswer={setAnswer} />;
    } else {
        return <></>;
    }
};
