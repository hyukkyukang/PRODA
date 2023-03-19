import React from "react";
import { Box, Paper, Typography } from "@mui/material";

export enum TaskTypes {
    YesNo = 1,
    NLAugmentation = 2,
}

export const taskTypeToInstruction = (taskType: number | undefined): string => {
    switch (taskType) {
        case TaskTypes.YesNo:
            return "A natural language query, corrsponding EVQA query, table excerpt, and query execution result is given below. Please understand them and answer the question below.";
        case TaskTypes.NLAugmentation:
            return "A natural language query, corrsponding EVQA query, table excerpt, and query execution result is given below. Please understand them and answer the question below.";
        default:
            return "Instrunction goes here...";
    }
};

export const Instruction = (props: { taskType: number | undefined }) => {
    const { taskType } = props;
    return (
        <React.Fragment>
            <Paper elevation={2}>
                <Box sx={{ marginLeft: "15px" }}>
                    {/* <Typography variant="h5">Instruction</Typography> */}
                    <Typography variant="h6">{taskTypeToInstruction(taskType)}</Typography>
                </Box>
            </Paper>
        </React.Fragment>
    );
};

export default Instruction;
