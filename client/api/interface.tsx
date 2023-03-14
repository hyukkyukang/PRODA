import { Task } from "../components/Collection/task";
import { UserAnswer } from "../components/Collection/answerSheet";

// Interfaces for request data client -> server
export interface IUpdateAnswerRequest {
    task: Task;
    answer: UserAnswer;
    workerId: string;
    taskID: number;
}

// Interfaces for response data client <- server
export interface ITaskResponse {
    isTaskReturned: boolean;
    task: Task;
}
