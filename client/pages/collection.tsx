import React, { useState, useEffect } from "react";
import { Switch, Box, Paper, Button, Step, Stepper, StepLabel, Grid } from "@mui/material";

import { Instruction } from "../components/Collection/instruction";
import { TaskTypes, CollectionData, dummyCollectionData1, dummyCollectionData2 } from "../components/Collection/collectionData";
import { ResultTable } from "../components/ResultTable/resultTable";
import { EVQLTable } from "../components/VQL/EVQLTable";
import { YesNoAnswerSheet, AugmentationAnswerSheet } from "../components/Collection/answerSheet";
import { getTask } from "../api/connect";

const steps = ["Step 1", "Step 2", "Step 3"];

export const Collection = (props: any) => {
    const [currentStep, setCurrentStep] = useState(0);
    const [collectionData, setCollectionData] = useState<CollectionData>(dummyCollectionData1);

    const MyStepper: JSX.Element = (
        <React.Fragment>
            <br />
            <Stepper nonLinear activeStep={currentStep}>
                {steps.map((label, idx) => (
                    <Step key={label}>
                        <StepLabel>{label}</StepLabel>
                    </Step>
                ))}
            </Stepper>
            <br />
        </React.Fragment>
    );

    const onSubmitHandler = () => {
        setCollectionData(dummyCollectionData2);
        setCurrentStep(1);
    };

    const answerSheet = () => {
        if (collectionData.taskType === TaskTypes.YesNo) {
            return <YesNoAnswerSheet />;
        } else {
            return <AugmentationAnswerSheet />;
        }
    };

    const getTaskHandler = async () => {
        const task = await getTask();
        console.log(`task:${JSON.stringify(task)}`);
    };

    useEffect(() => {
        getTaskHandler();
    }, []);

    return (
        <React.Fragment>
            <Grid container sx={{ background: "white", color: "black" }}>
                <Grid item xs={12}>
                    <h1 style={{ marginLeft: "10px" }}>Data Collection</h1>
                    {MyStepper}
                    <div style={{ marginLeft: "1%", width: "98%" }}>
                        <Instruction taskType={collectionData.taskType} />
                        <br />
                        <Paper elevation={2}>
                            <Box style={{ marginLeft: "15px" }}>
                                <br />
                                <b>Natural Language Query</b>
                                <br />
                                <span>{collectionData.nl}</span>
                                <br />
                                <br />
                                <Grid container spacing={2}>
                                    <Grid item xs={12} sm={6}>
                                        <b>EVQL</b>
                                        <br />
                                        <EVQLTable evqlRoot={collectionData.evql} childListPath={collectionData.evqlTreePath} editable={false} />
                                    </Grid>
                                    <Grid item xs={12} sm={6}>
                                        <b>Table Excerpt</b>
                                        <ResultTable queryResult={collectionData.tableExcerpt} />
                                        <br />
                                        <b>Query Result</b>
                                        <ResultTable queryResult={collectionData.queryResult} />
                                    </Grid>
                                </Grid>
                                <br />
                            </Box>
                        </Paper>
                        <br />
                        {answerSheet()}
                        <br />
                        <Button variant="contained" color="success" onClick={onSubmitHandler}>
                            Submit
                        </Button>
                        <br />
                        <br />
                    </div>
                </Grid>
            </Grid>
        </React.Fragment>
    );
};

export default Collection;
