import { EVQLTree, aggFunctions, binaryOperators } from "../VQL/EVQL";

export enum TaskTypes {
    YesNo = 1,
    NLAugmentation,
}

export interface CollectionData {
    nl: string;
    sql: string;
    evql: EVQLTree;
    evqlTreePath: number[];
    queryType: string;
    tableExcerpt: any[];
    queryResult: any[];
    dbName: string;
    taskType: number;
}

const dummyEVQL: EVQLTree = {
    node: {
        header_names: ["cars", "model", "horsepower_avg", "max_speed_avg"],
        header_aliases: ["cars", "model", "horsepower_avg", "max_speed_avg"],
        foreach: null,
        projection: {
            headers: [
                { id: 1, agg_type: 0 },
                { id: 2, agg_type: 0 },
            ],
        },
        predicate: {
            clauses: [
                {
                    conditions: [{ header_id: 3, func_type: "Selecting", op_type: binaryOperators.indexOf(">"), r_operand: "200" }],
                },
            ],
        },
    },
    children: [
        {
            node: {
                header_names: ["cars", "id", "model", "horsepower", "max_speed", "year", "price"],
                header_aliases: ["cars", "id", "model", "horsepower", "max_speed", "year", "price"],
                foreach: null,
                projection: {
                    headers: [
                        { id: 2, agg_type: aggFunctions.indexOf("none") },
                        { id: 3, agg_type: aggFunctions.indexOf("avg") },
                        { id: 4, agg_type: aggFunctions.indexOf("avg") },
                    ],
                },
                predicate: {
                    clauses: [
                        {
                            conditions: [{ header_id: 2, func_type: "Grouping" }],
                        },
                    ],
                },
            },
            children: [],
            enforce_t_alias: false,
        },
    ],
    enforce_t_alias: false,
};

export const dummyCollectionData1: CollectionData = {
    nl: "Show model, average horsepower, and average max speed of cars for each model",
    sql: "SELECT model, AVG(horsepower), AVG(max_speed) FROM cars GROUP BY model",
    evql: Object.assign({}, dummyEVQL),
    evqlTreePath: [0],
    tableExcerpt: [
        { id: 1, model: "A", horsepower: 100, max_speed: 200, year: 2000, price: 10000 },
        { id: 2, model: "B", horsepower: 200, max_speed: 300, year: 2000, price: 70000 },
        { id: 3, model: "C", horsepower: 300, max_speed: 400, year: 2000, price: 60000 },
        { id: 4, model: "D", horsepower: 400, max_speed: 500, year: 2000, price: 50000 },
        { id: 5, model: "E", horsepower: 500, max_speed: 600, year: 2000, price: 40000 },
        { id: 6, model: "A", horsepower: 300, max_speed: 300, year: 2012, price: 30000 },
        { id: 7, model: "A", horsepower: 200, max_speed: 200, year: 2010, price: 20000 },
        { id: 8, model: "B", horsepower: 100, max_speed: 200, year: 2000, price: 10000 },
    ],
    queryResult: [
        { model: "A", horsepower_avg: 200, max_speed_avg: 233 },
        { model: "B", horsepower_avg: 150, max_speed_avg: 250 },
        { model: "C", horsepower_avg: 300, max_speed_avg: 400 },
        { model: "D", horsepower_avg: 400, max_speed_avg: 500 },
        { model: "E", horsepower_avg: 500, max_speed_avg: 600 },
    ],
    queryType: "Grouping",
    dbName: "cars",
    taskType: TaskTypes.YesNo,
};

export const dummyCollectionData2: CollectionData = {
    nl: "Show average horsepower of cars for each model whose average max_speed is less than 300",
    sql: "SELECT model, AVG(horsepower) FROM cars GROUP BY model Having AVG(max_speed) < 300",
    evql: Object.assign({}, dummyEVQL),
    evqlTreePath: [],
    tableExcerpt: [
        { model: "A", horsepower_avg: 200, max_speed_avg: 233 },
        { model: "B", horsepower_avg: 150, max_speed_avg: 250 },
        { model: "C", horsepower_avg: 300, max_speed_avg: 400 },
        { model: "D", horsepower_avg: 400, max_speed_avg: 500 },
        { model: "E", horsepower_avg: 500, max_speed_avg: 600 },
    ],
    queryResult: [
        { model: "A", horsepower_avg: 200 },
        { model: "B", horsepower_avg: 150 },
    ],
    queryType: "Grouping",
    dbName: "cars",
    taskType: TaskTypes.NLAugmentation,
};
