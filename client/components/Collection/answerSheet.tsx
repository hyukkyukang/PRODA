import React, { useEffect } from "react";
import { Typography, Input, Paper, Switch, FormGroup, FormControlLabel, createTheme, ThemeProvider } from "@mui/material";

import { TaskTypes } from "./instruction";

export interface Answer {
    type: TaskTypes;
    nl: string;
    isCorrect?: boolean;
}

export interface AnswerSheetProps {
    taskType: TaskTypes | undefined;
    answer: Answer;
    setAnswer: React.Dispatch<React.SetStateAction<Answer>>;
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

export const YesNoAnswerSheet = (props: { answer: Answer; setAnswer: React.Dispatch<React.SetStateAction<Answer>> }) => {
    const { answer, setAnswer } = props;
    const [ischecked, setIsChecked] = React.useState<boolean>(false);

    const handleSwitchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        setIsChecked(event.target.checked);
        setAnswer({ ...answer, isCorrect: event.target.checked });
    };

    const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
        setAnswer({ ...answer, nl: event.target.value });
    };

    useEffect(() => {
        setAnswer({ ...answer, type: TaskTypes.NLAugmentation });
    }, []);

    const Button = (
        <ThemeProvider theme={theme}>
            <FormGroup>
                <FormControlLabel control={<Switch onChange={handleSwitchChange} />} label={ischecked ? "Is Correct" : "Is not correct"} />
            </FormGroup>
        </ThemeProvider>
    );
    return (
        <React.Fragment>
            <Paper elevation={2}>
                <div style={{ marginLeft: "10px" }}>
                    <Typography sx={{ paddingTop: "10px" }} variant="h6">
                        Is the given natural language query correct?
                    </Typography>
                    <div style={{ marginLeft: "10px" }}>{Button}</div>
                </div>
            </Paper>
            <br />
            <br />
            {!ischecked ? (
                <Paper elevation={2}>
                    <div style={{ marginLeft: "10px" }}>
                        <Typography sx={{ paddingTop: "10px" }} variant="h6">
                            What is the correct natural language query?
                        </Typography>
                        <Input value={answer.nl} placeholder="Type correct natural language query" sx={{ width: "98%" }} onChange={inputHandler} />
                        <br />
                        <br />
                    </div>
                </Paper>
            ) : null}
        </React.Fragment>
    );
};

export const AugmentationAnswerSheet = (props: { answer: Answer; setAnswer: React.Dispatch<React.SetStateAction<Answer>> }) => {
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
                        Please rephrase the given natural language query
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
    const { taskType, answer, setAnswer } = props;
    if (taskType === TaskTypes.YesNo) {
        return <YesNoAnswerSheet answer={answer} setAnswer={setAnswer} />;
    } else if (taskType === TaskTypes.NLAugmentation) {
        return <AugmentationAnswerSheet answer={answer} setAnswer={setAnswer} />;
    } else {
        return <></>;
    }
};
