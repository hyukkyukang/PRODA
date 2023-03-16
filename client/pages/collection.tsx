import { Grid, Paper } from "@mui/material";
import React, { useContext, useEffect, useMemo, useRef, useState } from "react";
import { useQuery, useMutation } from "react-query";

import CircularProgress from "@mui/material/CircularProgress";
import { fetchTask, sendWorkerAnswer } from "../api/connect";
import { ITaskResponse } from "../api/interface";
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
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", type: 0 });
    // Local state variables
    // AMT informations
    const [hitId, setHitId] = useState("");
    const [assignmentId, setAssignmentId] = useState("");
    const [turkSubmitTo, setTurkSubmitTo] = useState("");
    const [workerID, setWorkerID] = useState("");
    const [taskID, setTaskID] = useState(-1);
    const [isAnswerSubmitted, setIsAnswerSubmitted] = useState(false);
    // Variables to change state step-by-step to call API once
    const [isInitalized, setIsInitalized] = useState(false);
    const [isURLParsed, setIsURLParsed] = useState(false);

    // To handle submission
    const formRef = useRef<HTMLFormElement>(null);

    // Fetching Data
    // const { isLoading, isError, data, error } = useQuery<ITaskResponse>(["fetchTask", workerId, taskID, isRefetch], fetchTask, { enabled: workerId !== "",  });
    const {
        data,
        isError,
        isLoading,
        isSuccess,
        mutate: mutate,
    } = useMutation({
        mutationFn: (params: { workerID: string; taskID: number | undefined; isSkip: boolean }) => fetchTask(params),
    });
    const currentTask = useMemo<Task | null>(() => (data?.isTaskReturned ? data.task : null), [data]);

    const onSubmitHandler = () => {
        // This should be called only when data is not null
        if (currentTask) {
            // Send current step's info to the server
            const task: Task = currentTask;
            sendWorkerAnswer({ task: task, answer: answer, workerID: workerID });

            // Submit assignment
            if (enableAMTSubmission && formRef.current) {
                formRef.current.submit();
            }
            setIsAnswerSubmitted(true);
        }
    };

    const onSkipHandler = () => {
        console.log(`inside taskID:${taskID}`);
        mutate({ workerID: workerID, taskID: taskID, isSkip: true });
    };

    console.log(`outside taskID: ${taskID}`);

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
                <input type="hidden" value={answer.type} name="taskType" id="taskType" />
                <input type="hidden" value={answer.nl} name="answerNL" id="answerNL" />
                <input type="hidden" value={currentTask?.taskID} name="taskId" id="taskId" />
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
        if (isAnswerSubmitted) {
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
    }, [isAnswerSubmitted, isLoading, isError, data, answer, taskID, currentTask]);

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
