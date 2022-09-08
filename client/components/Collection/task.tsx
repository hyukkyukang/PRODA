import { EVQLTree, EVQLNode } from "../VQL/EVQL";

export interface SubTask {
    nl: string;
    sql: string;
    evql: EVQLNode;
    tableExcerpt: { key: string }[];
    resultTable: { key: string }[];
}
export interface Task {
    nl: string;
    sql: string;
    evql: EVQLTree;
    queryType: number;
    dbName: string;
    taskType: number;
    subTasks: SubTask[];
}
