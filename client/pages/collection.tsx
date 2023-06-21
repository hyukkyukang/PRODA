import { Grid, Paper } from "@mui/material";
import CircularProgress from "@mui/material/CircularProgress";
import React, { useContext, useEffect, useMemo, useRef, useState } from "react";
import { useMutation } from "react-query";
import { fetchTask, sendWorkerAnswer } from "../api/connect";
import { AnswerSheet, UserAnswer } from "../components/Collection/answerSheet";
import { DialogToTutorial } from "../components/Collection/dialogToTutorial";
import { OverallTaskDescription } from "../components/Collection/overallTaskDescription";
import { QuerySheet } from "../components/Collection/querySheet";
import { SubmitFailedSnackbar } from "../components/Collection/submitFailedSnackbar";
import { SubmitSucceedSnackbar } from "../components/Collection/submitSucceedSnackbar";
import { Task } from "../components/Collection/task";
import { Header } from "../components/Header/collectionHeader";
import { RefContext } from "../pages/_app";
import { getConfig } from "../utils";

const config = getConfig();
const isAMTSubmissionMode = config.isAMTCollectionMode;

export const Collection = (props: any) => {
    // Ref
    const { targetRef } = useContext(RefContext);
    // Global state variables
    const [answer, setAnswer] = useState<UserAnswer>({ nl: "", isCorrect: undefined });
    const [answerSet, setAnswerSet] = useState<UserAnswer[]>([]);
    const [isDialogOpen, setIsDialogOpen] = useState<boolean>(true);
    // Local state variables
    const [taskSetIdx, setTaskSetIdx] = useState<number>(0);
    const [isSubmitSucceedSnackbarOpen, setIsSubmitSucceedSnackbarOpen] = React.useState<boolean>(false);
    const [isSubmitFailedSnackbarOpen, setIsSubmitFailedSnackbarOpen] = React.useState<boolean>(false);
    // AMT informations
    const [hitId, setHitId] = useState("");
    const [assignmentId, setAssignmentId] = useState("");
    const [turkSubmitTo, setTurkSubmitTo] = useState("");
    const [workerID, setWorkerID] = useState("");
    const [taskSetID, setTaskSetID] = useState<number | null>();
    // Variables to change state step-by-step to call API once
    const [isInitalized, setIsInitalized] = useState(false);
    const [isURLParsed, setIsURLParsed] = useState(false);
    const [isReadyToSendAMTAnswer, setIsReadyToSendAMTAnswer] = useState(false);

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
        mutationFn: (params: { workerID: string; taskSetID: number | undefined | null; isSkip: boolean }) => fetchTask(params),
    });
    const taskSet = useMemo<{ taskSetID: number; tasks: Task[] } | null>(() => (data?.isTaskReturned ? data.taskSet : null), [data]);
    const currentTask = useMemo<Task | null>(() => (taskSet && taskSet.tasks.length > taskSetIdx ? taskSet.tasks[taskSetIdx] : null), [taskSet, taskSetIdx]);
    const isAllTaskComplete = useMemo<boolean>(() => (taskSet?.tasks ? taskSetIdx + 1 >= taskSet?.tasks.length : false), [taskSet, taskSetIdx]);
    const isTaskSetComplete = useMemo<boolean>(() => (taskSet?.tasks ? taskSetIdx >= taskSet?.tasks.length : false), [taskSet, taskSetIdx]);
    const isAnswerNLValid = useMemo<boolean>(() => (answer?.nl && currentTask?.nl ? answer.nl != currentTask.nl : false), [answer, currentTask]);
    const isNotPreviewMode = useMemo<boolean>(
        () => (currentTask && (!isAMTSubmissionMode || (isAMTSubmissionMode && workerID)) ? true : false),
        [currentTask, workerID]
    );

    const onSubmitHandler = () => {
        // This should be called only when data is not null
        if (isNotPreviewMode) {
            if (isAnswerNLValid) {
                // Send current step's info to the server
                sendWorkerAnswer({ answer: answer, workerID: workerID, taskID: currentTask?.taskID, taskSetID: taskSet?.taskSetID });

                setIsSubmitSucceedSnackbarOpen(true);
                setTaskSetIdx(taskSetIdx + 1);
                setAnswerSet([...answerSet, answer]);

                // Submit assignment
                if (isAllTaskComplete) {
                    setIsReadyToSendAMTAnswer(true);
                }
                return true;
            } else {
                setIsSubmitFailedSnackbarOpen(true);
            }
        }
        return false;
    };

    const onSkipHandler = () => {
        if (isNotPreviewMode) {
            mutate({ workerID: workerID, taskSetID: taskSet?.taskSetID, isSkip: true });
        }
    };

    const getAMTInfo = () => {
        // Parse URL parameters
        const queryParams = new URLSearchParams(window.location.search);
        const hitId = queryParams.get("hitId") ? queryParams.get("hitId") : "";
        const assignmentId = queryParams.get("assignmentId") ? queryParams.get("assignmentId") : "";
        const turkSubmitTo = queryParams.get("turkSubmitTo") ? queryParams.get("turkSubmitTo") : "";
        const workerID = queryParams.get("workerId") ? queryParams.get("workerId") : "";
        const taskID = queryParams.get("taskID") ? queryParams.get("taskID") : "";
        const taskSetID = queryParams.get("taskSetID") ? queryParams.get("taskSetID") : "";

        // Set AMT information
        setHitId(hitId === null ? "" : hitId);
        setAssignmentId(assignmentId === null ? "" : assignmentId);
        setTurkSubmitTo(turkSubmitTo === null ? "" : turkSubmitTo);
        setWorkerID(workerID === null ? "" : workerID);
        setTaskSetID(taskSetID === null ? -1 : parseInt(taskSetID));
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
            mutate({ workerID: workerID, taskSetID: taskSetID, isSkip: false });
        }
    }, [isURLParsed]);

    //  Update taskID when data is updated
    useEffect(() => {
        if (!isLoading && data) {
            setTaskSetID(data?.taskSet?.taskSetID);
        }
    }, [data]);

    // Send answer to AMT when everything is done
    useEffect(() => {
        if (isReadyToSendAMTAnswer && isAMTSubmissionMode) {
            formRef.current?.submit();
        }
    }, [isReadyToSendAMTAnswer]);

    const AMTSubmissionForm = (
        <React.Fragment>
            <form action="https://workersandbox.mturk.com/mturk/externalSubmit" ref={formRef}>
                <input type="hidden" value={assignmentId} name="assignmentId" id="assignmentId" />
                <input type="hidden" value={JSON.stringify(answer)} name="answer" id="answer" />
                <input type="hidden" value={taskSet?.taskSetID} name="taskSetID" id="taskSetID" />
                <input type="hidden" value={workerID} name="workerID" id="workerID" />
            </form>
        </React.Fragment>
    );

    const collectionBody = (
        <div style={{ marginLeft: "1%", width: "98%" }}>
            <br />
            {/* Show saquery information for the current task */}
            <Paper elevation={2}>
                <OverallTaskDescription evqa={currentTask?.evqa} />
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
                <p> We appreciate your response. Your answer has been submitted successfully!</p>
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
    }, [isTaskSetComplete, isLoading, isError, data, answer, taskSetID, currentTask]);

    return (
        <React.Fragment>
            <div ref={targetRef}>
                <Grid container sx={{ background: "#f6efe8", color: "black" }}>
                    <Grid item xs={12}>
                        <React.Fragment>
                            <Header />
                            {componentBody}
                        </React.Fragment>
                    </Grid>
                </Grid>
            </div>
            <DialogToTutorial isDialogOpen={isDialogOpen} setIsDialogOpen={setIsDialogOpen} />
            <SubmitSucceedSnackbar isSubmitSucceedSnackbarOpen={isSubmitSucceedSnackbarOpen} setIsSubmitSucceedSnackbarOpen={setIsSubmitSucceedSnackbarOpen} />
            <SubmitFailedSnackbar isSubmitFailedSnackbarOpen={isSubmitFailedSnackbarOpen} setIsSubmitFailedSnackbarOpen={setIsSubmitFailedSnackbarOpen} />
        </React.Fragment>
    );
};

export default Collection;
