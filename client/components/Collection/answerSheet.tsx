import React from "react";
import { Typography, Input, Paper, Switch, FormGroup, FormControlLabel, createTheme, ThemeProvider } from "@mui/material";

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

export const YesNoAnswerSheet = () => {
    const [ischecked, setIsChecked] = React.useState<boolean>(false);

    const handleSwitchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        setIsChecked(event.target.checked);
    };

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
                        <Input placeholder="Type correct natural language query" sx={{ width: "98%" }} />
                        <br />
                        <br />
                    </div>
                </Paper>
            ) : null}
        </React.Fragment>
    );
};

export const AugmentationAnswerSheet = () => {
    return (
        <React.Fragment>
            <Paper elevation={2}>
                <div style={{ marginLeft: "10px" }}>
                    <Typography sx={{ paddingTop: "10px" }} variant="h6">
                        Please rephrase the given natural language query
                    </Typography>
                    <Input placeholder="Type rephrased natural language query" sx={{ width: "98%" }} />
                    <br />
                    <br />
                </div>
            </Paper>
        </React.Fragment>
    );
};
