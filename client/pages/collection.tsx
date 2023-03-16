import { Grid, Paper } from "@mui/material";
import React, { useContext, useEffect, useMemo, useRef, useState } from "react";
import { useMutation } from "react-query";

import CircularProgress from "@mui/material/CircularProgress";
import { fetchTask, sendWorkerAnswer } from "../api/connect";
import { AnswerSheet, UserAnswer } from "../components/Collection/answerSheet";
import { QuerySheet } from "../components/Collection/querySheet";
import { Task } from "../components/Collection/task";
import { Header } from "../components/Header/collectionHeader";
import { RefContext } from "../pages/_app";
import { TaskDescription } from "../components/Collection/taskDescription";

const enableAMTSubmission = false;

export const Collection = (props: any) => {
    // Ref
    const { targetRef } = useContext(RefContext);
    // Global state variables
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", isCorrect: undefined });
    // Local state variables
    const [taskSetIdx, setTaskSetIdx] = useState<number>(0);
    // AMT informations
    const [hitId, setHitId] = useState("");
    const [assignmentId, setAssignmentId] = useState("");
    const [turkSubmitTo, setTurkSubmitTo] = useState("");
    const [workerID, setWorkerID] = useState("");
    const [taskID, setTaskID] = useState(-1);
    // Variables to change state step-by-step to call API once
    const [isInitalized, setIsInitalized] = useState(false);
    const [isURLParsed, setIsURLParsed] = useState(false);

    // To handle submission
    const formRef = useRef<HTMLFormElement>(null);

    // Fetching Data
    const {
        data,
        isError,
        isLoading,
        isSuccess,
        mutate: mutate,
    } = useMutation({
        mutationFn: (params: { workerID: string; taskID: number | undefined; isSkip: boolean }) => fetchTask(params),
    });
    const taskSet = useMemo<{ taskSetID: number; tasks: Task[] } | null>(() => (data?.isTaskReturned ? data.taskSet : null), [data]);
    const currentTask = useMemo<Task | null>(() => (taskSet && taskSet.tasks.length > taskSetIdx ? taskSet.tasks[taskSetIdx] : null), [taskSet, taskSetIdx]);
    const isTaskSetComplete = useMemo<boolean>(() => (taskSet?.tasks ? taskSetIdx >= taskSet?.tasks.length : false), [taskSet, taskSetIdx]);

    const onSubmitHandler = () => {
        // This should be called only when data is not null
        if (currentTask) {
            // Send current step's info to the server
            sendWorkerAnswer({ answer: answer, workerID: workerID, taskID: currentTask?.taskID, taskSetID: taskSet?.taskSetID });

            // Submit assignment
            if (enableAMTSubmission && isTaskSetComplete && formRef.current) {
                formRef.current.submit();
            }
            setTaskSetIdx(taskSetIdx + 1);
        }
    };

    const onSkipHandler = () => {
        mutate({ workerID: workerID, taskID: taskID, isSkip: true });
    };

    const getAMTInfo = () => {
        // Parse URL parameters
        const queryParams = new URLSearchParams(window.location.search);
        const hitId = queryParams.get("hitId") ? queryParams.get("hitId") : "";
        const assignmentId = queryParams.get("assignmentId") ? queryParams.get("assignmentId") : "";
        const turkSubmitTo = queryParams.get("turkSubmitTo") ? queryParams.get("turkSubmitTo") : "";
        const workerID = queryParams.get("workerId") ? queryParams.get("workerId") : "a";
        const taskID = queryParams.get("taskID") ? queryParams.get("taskID") : "";

        // Set AMT information
        setHitId(hitId === null ? "" : hitId);
        setAssignmentId(assignmentId === null ? "" : assignmentId);
        setTurkSubmitTo(turkSubmitTo === null ? "" : turkSubmitTo);
        setWorkerID(workerID === null ? "" : workerID);
        setTaskID(taskID === null ? -1 : parseInt(taskID));
    };

    // Cascading useEffects to call API once
    useEffect(() => {
        setIsInitalized(true);
    }, []);

    useEffect(() => {
        if (isInitalized) {
            getAMTInfo();
            setIsURLParsed(true);
        }
    }, [isInitalized]);

    useEffect(() => {
        if (isURLParsed) {
            mutate({ workerID: workerID, taskID: taskID, isSkip: false });
        }
    }, [isURLParsed]);

    //  Update taskID when data is updated
    useEffect(() => {
        console.log(`data: ${JSON.stringify(data)} isloading:${isLoading}`);
        if (!isLoading && data) {
            setTaskID(data?.task?.taskID);
        }
    }, [data]);

    const AMTSubmissionForm = (
        <React.Fragment>
            <form action="https://workersandbox.mturk.com/mturk/externalSubmit" ref={formRef}>
                <input type="hidden" value={assignmentId} name="assignmentId" id="assignmentId" />
                <input type="hidden" value={answer.nl} name="answerNL" id="answerNL" />
                <input type="hidden" value={taskSet?.taskSetID} name="taskSetID" id="taskSetID" />
                <input type="hidden" value={answer.isCorrect === undefined ? "true" : answer.isCorrect.toString()} name="isCorrect" id="isCorrect" />
            </form>
        </React.Fragment>
    );

    const collectionBody = (
        <div style={{ marginLeft: "1%", width: "98%" }}>
            <br />
            {/* Show saquery information for the current task */}
            <Paper elevation={2}>
                <TaskDescription evql={currentTask?.evql} />
            </Paper>
            <br />
            <Paper elevation={2}>
                <QuerySheet currentTask={currentTask} />
            </Paper>
            {/* Show query information for the previous tasks (to complete the current task) */}
            <AnswerSheet taskNL={currentTask?.nl} answer={answer} setAnswer={setAnswer} onSubmitHandler={onSubmitHandler} onSkipHandler={onSkipHandler} />
            <br />
            {AMTSubmissionForm}
        </div>
    );

    const waitingBody = (
        <div style={{ height: "100px", display: "flex", textAlign: "center", justifyContent: "center", alignItems: "center" }}>
            <div style={{ display: "inline-block" }}>
                <p> Loading data... </p>
            </div>
            <div style={{ display: "inline-block", paddingLeft: "3px", paddingBottom: "10px" }}>
                <CircularProgress color="inherit" size="20px" />
            </div>
        </div>
    );

    const errorBody = (
        <div style={{ height: "100px", display: "flex", textAlign: "center", justifyContent: "center", alignItems: "center" }}>
            <div style={{ display: "inline-block" }}>
                <p> Unexpected Error. Try Refresh! </p>
            </div>
        </div>
    );

    const noTaskBody = (
        <div style={{ height: "100px", display: "flex", textAlign: "center", justifyContent: "center", alignItems: "center" }}>
            <div style={{ display: "inline-block" }}>
                <p> There are no more task left... </p>
                <p> Please ask the admin to generate more tasks. </p>
            </div>
        </div>
    );

    const answerSubmittedBody = (
        <div style={{ height: "100px", display: "flex", textAlign: "center", justifyContent: "center", alignItems: "center" }}>
            <div style={{ display: "inline-block" }}>
                <p> Answer successfully submitted! </p>
            </div>
        </div>
    );

    const componentBody = useMemo((): JSX.Element => {
        if (isTaskSetComplete) {
            return answerSubmittedBody;
        } else if (isLoading) {
            return waitingBody;
        } else if (isError) {
            return errorBody;
        } else if (currentTask === null) {
            return noTaskBody;
        } else {
            return collectionBody;
        }
    }, [isTaskSetComplete, isLoading, isError, data, answer, taskID, currentTask]);

    return (
        <React.Fragment>
            <div ref={targetRef}>
                <Grid container sx={{ background: "#f6efe8", color: "black" }}>
                    <Grid item xs={12}>
                        <>
                            <Header />
                            {componentBody}
                        </>
                    </Grid>
                </Grid>
            </div>
        </React.Fragment>
    );
};

export default Collection;
