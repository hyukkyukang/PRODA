import React from "react";
import { Box, Paper, Typography } from "@mui/material";

import { TaskTypes } from "./collectionData";

export const taskTypeToInstruction = (taskType: number): string => {
    switch (taskType) {
        case TaskTypes.YesNo:
            return "Below is a natural language query with its corresponding EVQL query. We show the query execution result on a given table excerpt.";
        case TaskTypes.NLAugmentation:
            return "augmentation";
        default:
            return "Default instrunction goes here...";
    }
};

export const Instruction = (props: { taskType: number }) => {
    const { taskType } = props;
    return (
        <React.Fragment>
            <Paper elevation={2}>
                <Box sx={{ marginLeft: "15px" }}>
                    <Typography variant="h5">Instruction</Typography>
                    <Typography variant="h6">{taskTypeToInstruction(taskType)}</Typography>
                </Box>
            </Paper>
        </React.Fragment>
    );
};

export default Instruction;
