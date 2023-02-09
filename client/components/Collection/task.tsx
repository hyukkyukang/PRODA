import { EVQLTree, EVQLNode } from "../VQL/EVQL";

export interface Task {
    nl: string;
    sql: string;
    evql: EVQLTree;
    queryType: number;
    taskType: number;
    dbName: string;
    tableExcerpt: { key: string }[];
    resultTable: { key: string }[];
    history: Task[];
    blockId: string;
}
