import ContentPasteGoIcon from "@mui/icons-material/ContentPasteGo";
import SendIcon from "@mui/icons-material/Send";
import { Button, createTheme, FormGroup, Paper, ThemeProvider, Typography } from "@mui/material";
import Checkbox from "@mui/material/Checkbox";
import { pink } from "@mui/material/colors";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Snackbar from "@mui/material/Snackbar";
import TextField from "@mui/material/TextField";
import Tooltip from "@mui/material/Tooltip";
import React, { useMemo } from "react";
import MuiAlert, { AlertProps } from "@mui/material/Alert";

export interface UserAnswer {
    nl: string;
    isCorrect: boolean | undefined;
}

export interface AnswerSheetProps {
    taskNL: string | undefined;
    answer: UserAnswer;
    setAnswer: React.Dispatch<React.SetStateAction<UserAnswer>>;
    onSubmitHandler: () => boolean;
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

const enabledSubmitButton = (onSubmitHandler: any) => {
    return (
        <Button variant="contained" color="success" endIcon={<SendIcon />} onClick={onSubmitHandler}>
            Submit
        </Button>
    );
};

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(function Alert(props, ref) {
    return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
});

const disabledSubmitButton = (
    <Button variant="contained" endIcon={<SendIcon />} disabled>
        Submit
    </Button>
);

const firstInstruction =
    'Does the given sentence correctly summarize all the EVQA blocks above?\nPlease select "is not correct" if the sentence is wrong, ambiguous, or has any missing information.';
const instructionAskingRephrase = "Please rephrase to a more natural sentence";
const instructionAskingRevise = "Please write a correct sentence";
const skipButtonText = "Not sure, skip this task";

export const AnswerSheet = (props: AnswerSheetProps) => {
    const { taskNL, answer, setAnswer, onSubmitHandler, onSkipHandler } = props;
    // Answer sheet
    const [yesIsChecked, setYesIsChecked] = React.useState<boolean>(false);
    const [noIsChecked, setNoIsChecked] = React.useState<boolean>(false);
    const [isDialogOpen, setIsDialogOpen] = React.useState<boolean>(false);
    const [isSnackbarOpen, setIsSnackbarOpen] = React.useState<boolean>(false);

    const isYesNoButtonClicked = useMemo(() => yesIsChecked || noIsChecked, [yesIsChecked, noIsChecked]);
    const secondInstruction = useMemo(() => (yesIsChecked ? instructionAskingRephrase : instructionAskingRevise), [yesIsChecked]);

    const openSnackbar = () => {
        setIsSnackbarOpen(true);
    };

    const closeSnackbar = (event?: React.SyntheticEvent | Event, reason?: string) => {
        if (reason === "clickaway") {
            return;
        }
        setIsSnackbarOpen(false);
    };

    const submitButtonHandler = () => {
        const isSubmitted = onSubmitHandler();
        if (isSubmitted) {
            openSnackbar();
            // Clear answer fields
            setYesIsChecked(false);
            setNoIsChecked(false);
            setAnswer({ ...answer, nl: "" });
        }
    };

    const submitButton = useMemo(
        () => (answer?.nl ? enabledSubmitButton(submitButtonHandler) : disabledSubmitButton),
        [noIsChecked, yesIsChecked, answer, answer?.nl, onSubmitHandler]
    );

    const invertSkipDialogState = () => {
        setIsDialogOpen(!isDialogOpen);
    };

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
        setAnswer({ ...answer, nl: taskNL ? taskNL : "" });
    };

    const submissionSnackbar = (
        <Snackbar open={isSnackbarOpen} autoHideDuration={3000} onClose={closeSnackbar} anchorOrigin={{ vertical: "bottom", horizontal: "center" }}>
            <Alert onClose={closeSnackbar} severity="success" sx={{ width: "100%" }}>
                Answer submitted
            </Alert>
        </Snackbar>
    );

    const yesNoButtons = (
        <ThemeProvider theme={theme}>
            <FormGroup>
                <div style={{ display: "inline", paddingLeft: "10px" }}>
                    <div style={{ display: "inline-block" }}>
                        <Typography variant="body1" gutterBottom>
                            Is correct
                        </Typography>
                    </div>
                    <div style={{ display: "inline-block" }}>
                        <Checkbox color="success" checked={yesIsChecked} onChange={handleIsYesClicked} />
                    </div>
                    <div style={{ display: "inline-block", paddingLeft: "10px" }}>
                        <Typography variant="body1" gutterBottom>
                            Is not correct
                        </Typography>
                    </div>
                    <div style={{ display: "inline-block", paddingLeft: "10px" }}>
                        <Checkbox sx={{ color: pink[600], "&.Mui-checked": { color: pink[600] } }} checked={noIsChecked} onChange={handleIsNoClicked} />
                    </div>
                    <div style={{ display: "inline-block", paddingLeft: "20px" }}>
                        <Button variant="outlined" color="error" onClick={invertSkipDialogState}>
                            {skipButtonText}
                        </Button>
                    </div>
                    <Dialog
                        open={isDialogOpen}
                        onClose={invertSkipDialogState}
                        aria-labelledby="alert-dialog-title"
                        aria-describedby="alert-dialog-description"
                    >
                        <DialogTitle id="alert-dialog-title">{"Skipping the current task?"}</DialogTitle>
                        <DialogContent>
                            <DialogContentText id="alert-dialog-description">Do you want to skip this task and get another one?</DialogContentText>
                        </DialogContent>
                        <DialogActions>
                            <Button onClick={invertSkipDialogState}>No</Button>
                            <Button
                                onClick={() => {
                                    onSkipHandler();
                                    invertSkipDialogState();
                                }}
                                autoFocus
                            >
                                Yes
                            </Button>
                        </DialogActions>
                    </Dialog>
                </div>
            </FormGroup>
        </ThemeProvider>
    );

    const pasteButton = (
        <Tooltip title="Paste given sentence" placement="top">
            <button style={{ marginTop: "5px", fontSize: 0.5 }} onClick={pasteClickHandler}>
                <ContentPasteGoIcon />
            </button>
        </Tooltip>
    );

    return (
        <React.Fragment>
            <br />
            <Paper elevation={2} style={{ overflowX: "scroll", padding: "18px" }}>
                <h1>Question</h1>
                <div>
                    <div style={{ display: "inline-block" }}>
                        <Typography variant="h6" sx={{ paddingTop: "10px", whiteSpace: "pre-line" }}>
                            {firstInstruction}
                        </Typography>
                    </div>
                    <div style={{ display: "inline-block", verticalAlign: "middle" }}>
                        <div style={{ marginLeft: "10px" }}>{yesNoButtons}</div>
                    </div>
                </div>
                <br />
                {isYesNoButtonClicked ? (
                    <React.Fragment>
                        <div>
                            <div style={{ display: "inline-block" }}>
                                <Typography variant="h6" sx={{ paddingTop: "10px" }}>
                                    {secondInstruction}
                                </Typography>
                            </div>
                            <div style={{ display: "inline-block", paddingLeft: "20px" }}>{pasteButton}</div>
                        </div>
                        <div>
                            <div style={{ display: "inline-block", width: "700px" }}>
                                <TextField
                                    value={answer.nl}
                                    id="outlined-multiline-static"
                                    multiline
                                    rows={4}
                                    defaultValue="Type your answer here"
                                    sx={{ width: "100%" }}
                                    onChange={inputHandler}
                                />
                            </div>
                            <div style={{ display: "inline-block", paddingLeft: "15px", verticalAlign: "bottom" }}>{submitButton}</div>
                        </div>
                        <br />
                    </React.Fragment>
                ) : null}
            </Paper>
            {submissionSnackbar}
        </React.Fragment>
    );
};
