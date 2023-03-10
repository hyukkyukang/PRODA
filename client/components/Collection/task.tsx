import { EVQLTree } from "../VQL/EVQL";

export interface Task {
    nl: string;
    nl_mapping: Array<[string, number, number]>;
    sql: string;
    evql: EVQLTree;
    queryType: number;
    taskType: number;
    dbName: string;
    tableExcerpt: { key: string }[];
    resultTable: { key: string }[];
    history: Task[];
    blockId: string;
    taskId: number;
}
