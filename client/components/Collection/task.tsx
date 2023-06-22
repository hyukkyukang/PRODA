import { EVQATree } from "../VQA/EVQA";

export interface Task {
    nl: string;
    nl_mapping: Array<[string, number, number]>;
    sql: string;
    evqa: EVQATree;
    queryType: number;
    dbName: string;
    tableExcerpt: { key: string }[];
    resultTable: { key: string }[];
    subTasks: Task[];
    taskID: number;
}

export interface TaskSet {
    taskSetID: number;
    tasks: Task[];
}
