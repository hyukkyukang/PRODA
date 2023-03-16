import { EVQLTree } from "../VQL/EVQL";

export interface Task {
    nl: string;
    nl_mapping: Array<[string, number, number]>;
    sql: string;
    evql: EVQLTree;
    queryType: number;
    dbName: string;
    tableExcerpt: { key: string }[];
    resultTable: { key: string }[];
    history: Task[];
    blockID: string;
    taskID: number;
}

export interface TaskSet {
    taskSetID: number;
    tasks: Task[];
}
