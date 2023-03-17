import { Task } from "../components/Collection/task";
import { UserAnswer } from "../components/Collection/answerSheet";

// Interfaces for request data client -> server
export interface IUpdateAnswerRequest {
    answer: UserAnswer;
    workerId: string;
    taskID: number;
    taskSetID: number;
}

export interface IFetchTaskRequest {
    workerID: string;
    taskSetID: number;
    isSkip: boolean;
}

// Interfaces for response data client <- server

export interface IFetchTaskResponse {
    isTaskReturned: boolean;
    taskSet: {
        taskSetID: number;
        tasks: Task[];
    };
}
export interface IRunEVQA {
    evqaStr: string;
}

export interface IRunEVQAResponse {
    sql: string;
    result: any[];
}

export interface IRunSQL {
    sql: string;
}

export interface IRunSQLResponse {
    sql: any[];
}
