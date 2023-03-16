import ContentPasteGoIcon from "@mui/icons-material/ContentPasteGo";
import { Button, createTheme, FormGroup, Input, Paper, ThemeProvider, Typography } from "@mui/material";
import TextField from "@mui/material/TextField";
import Checkbox from "@mui/material/Checkbox";
import { pink } from "@mui/material/colors";
import React, { useEffect, useMemo } from "react";
import { TaskTypes } from "./instruction";

export interface UserAnswer {
    type: TaskTypes;
    nl: string;
    isCorrect?: boolean;
}

export interface AnswerSheetProps {
    taskNL: string | undefined;
    answer: UserAnswer;
    setAnswer: React.Dispatch<React.SetStateAction<UserAnswer>>;
    onSubmitHandler: () => void;
    onSkipHandler: () => void;
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

const enabledSubmitButton = (onSubmitHandler: any, isSubmitted: any, setIsSubmitted: any) => {
    const handlerWrapper = () => {
        setIsSubmitted(true);
        if (!isSubmitted) {
            onSubmitHandler();
        }
    };
    return (
        <Button variant="contained" color="success" onClick={handlerWrapper}>
            Submit
        </Button>
    );
};

const disabledSubmitButton = (
    <Button variant="contained" disabled>
        Submit
    </Button>
);

const instructionAskingRephrase = "Please rephrase the sentence";
const instructionAskingRevise = "Please correctly write the sentence";

export const AnswerSheet = (props: AnswerSheetProps) => {
    const { taskNL, answer, setAnswer, onSubmitHandler, onSkipHandler } = props;
    // Answer sheet
    const [yesIsChecked, setYesIsChecked] = React.useState<boolean>(false);
    const [noIsChecked, setNoIsChecked] = React.useState<boolean>(false);
    // To prevent multiple submission
    const [isSubmitted, setIsSubmitted] = React.useState<boolean>(false);

    const submitButton = useMemo(
        () => (answer?.nl ? enabledSubmitButton(onSubmitHandler, isSubmitted, setIsSubmitted) : disabledSubmitButton),
        [noIsChecked, yesIsChecked, answer, answer?.nl, onSubmitHandler, isSubmitted]
    );
    const isYesNoButtonClicked = useMemo(() => yesIsChecked || noIsChecked, [yesIsChecked, noIsChecked]);
    const instruction2 = useMemo(() => (yesIsChecked ? instructionAskingRephrase : instructionAskingRevise), [yesIsChecked]);

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
        } else {
        }
        setAnswer({ ...answer, isCorrect: !event.target.checked, nl: "" });
    };

    const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
        setAnswer({ ...answer, nl: event.target.value });
    };

    const pasteClickHandler = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        setAnswer({ ...answer, nl: taskNL });
    };

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
                    <div style={{ display: "inline-block", paddingLeft: "10px" }}>
                        <button onClick={onSkipHandler}>Skip this task and get another task</button>
                    </div>
                </div>
            </FormGroup>
        </ThemeProvider>
    );
    return (
        <React.Fragment>
            <br />
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
            {isYesNoButtonClicked ? (
                <React.Fragment>
                    <Paper elevation={2} style={{ height: "100px", overflowX: "scroll" }}>
                        <div style={{ marginLeft: "10px" }}>
                            <Typography sx={{ paddingTop: "10px" }}>{instruction2}</Typography>
                            <div style={{ display: "inline-block", paddingLeft: "10px", width: "500px" }}>
                                <TextField
                                    value={answer.nl}
                                    id="outlined-multiline-static"
                                    label="Multiline"
                                    multiline
                                    rows={4}
                                    defaultValue="Type your answer here"
                                    sx={{ width: "100%" }}
                                    onChange={inputHandler}
                                />
                                {/* <Input value={answer.nl} placeholder="Type your answer here" sx={{ width: "100%" }} onChange={inputHandler} /> */}
                            </div>
                            <div style={{ display: "inline-block" }}>
                                <button style={{ marginTop: "5px", fontSize: 1 }} onClick={pasteClickHandler}>
                                    <ContentPasteGoIcon />
                                </button>
                            </div>
                            <div style={{ display: "inline-block", paddingLeft: "15px" }}>{submitButton}</div>
                        </div>
                    </Paper>
                    <br />
                </React.Fragment>
            ) : null}
        </React.Fragment>
    );
};
