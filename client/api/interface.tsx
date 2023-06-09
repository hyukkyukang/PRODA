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
<<<<<<< HEAD
    workerId: string;
=======
    workerID: string;
>>>>>>> 3852206c33520deb109d3f8ae41a25238b1d87ba
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
export interface IRunEVQL {
    evqlStr: string;
}

export interface IRunEVQLResponse {
    sql: string;
    result: any[];
}

export interface IRunSQL {
    sql: string;
}

export interface IRunSQLResponse {
    sql: any[];
}
