import { EVQLTree } from "../VQL/EVQL";

export interface IDate {
    year: number;
    month: number;
    day: number;
}

export const QueryType = {
    WHEREScalarComparison: "WHERE: scalar comparison",
    WHEREQuantifiedScalarComparison: "WHERE: Quantified scalar comparison",
    WHEREAttAggComparison: "WHERE: Attribute-aggregation comparison",
    WHEREConstAggComparison: "WHERE: Constant-aggregation comparison",
    WHERESetMembershipCheckingWithIn: "WHERE: Set membership checking (IN)",
    WHERESetMembershipCheckingWithNotIn: "WHERE: Set membership checking (NOT IN)",
    WHEREExistentialCheckingWithExists: "WHERE: Existential checking (EXISTS)",
    WHEREExistentialCheckingWithNotExists: "WHERE: Existential checking (NOT EXISTS)",
    HAVINGAggScalarComparison: "HAVING: Aggregation-scalar comparison",
    HAVINGAggQuantifiedScalarComparison: "HAVING: Aggregation-quantified scalar comparison",
    HAVINGAggAggComparison: "HAVING: Aggregation-aggregation comparison",
    HAVINGSetMembershipCheckingWithIn: "HAVING: Set membership checking (IN)",
    HAVINGSetMembershipCheckingWithNotIn: "HAVING: Set membership checking (NOT IN)",
    HAVINGExistentialCheckingWithExists: "HAVING: Existential checking (EXISTS)",
    HAVINGExistentialCheckingWithNotExists: "HAVING: Existential checking (NOT EXISTS)",
    FROMScalarSubQuery: "FROM: Scalar SubQuery",
    FROMAggSubQuery: "FROM: Subquery with aggregation",
    FROMNotScalarNotAggSubQuery: "FROM: Not scalar and without aggregation",
};

export const dummyGoalNumOfQueries: { [key: string]: number } = Object.values(QueryType).reduce((acc, value) => {
    return { ...acc, [value]: 5 };
}, {});

export interface IPairData {
    nl: string;
    evql: EVQLTree;
    sql: string;
    queryType: string;
    date: IDate;
    userName: string;
}

export const dateToString = (date: IDate) => {
    return `${date.year}.${date.month}.${date.day}`;
};

export const dummyPairData: IPairData[] = [
    {
        nl: "Show all cars",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT * FROM cars",
        queryType: QueryType.WHEREScalarComparison,
        date: { year: 2022, month: 9, day: 1 },
        userName: "John",
    },
    {
        nl: "Count all cars",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT COUNT(*) FROM cars",
        queryType: QueryType.WHEREScalarComparison,
        date: { year: 2022, month: 9, day: 1 },
        userName: "John",
    },
    {
        nl: "Count all cars produced in year 2022",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT COUNT(*) FROM cars WHERE year = 2022",
        queryType: QueryType.WHEREQuantifiedScalarComparison,
        date: { year: 2022, month: 9, day: 3 },
        userName: "John",
    },
    {
        nl: "Show all models",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT COUNT(model) FROM cars",
        queryType: QueryType.WHEREAttAggComparison,
        date: { year: 2022, month: 9, day: 4 },
        userName: "John",
    },
    {
        nl: "Show all models produced in year 2022",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT COUNT(model) FROM cars WHERE year = 2022",
        queryType: QueryType.WHEREConstAggComparison,
        date: { year: 2022, month: 9, day: 5 },
        userName: "John",
    },
    // By Jane
    {
        nl: "Show all model in year 2012",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT model FROM cars WHERE year = 2012",
        queryType: QueryType.WHEREScalarComparison,
        date: { year: 2022, month: 8, day: 1 },
        userName: "Jane",
    },
    {
        nl: "Count all model",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT COUNT(model) FROM cars",
        queryType: QueryType.WHEREScalarComparison,
        date: { year: 2022, month: 8, day: 1 },
        userName: "Jane",
    },
    {
        nl: "Show max_speed of all cars produced in year 2012",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT id, max_speed FROM cars WHERE year = 2012",
        queryType: QueryType.WHEREQuantifiedScalarComparison,
        date: { year: 2022, month: 8, day: 3 },
        userName: "Jane",
    },
    {
        nl: "Show all models order by horsepower",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT id, horsepower FROM cars ORDER BY horsepower",
        queryType: QueryType.WHEREAttAggComparison,
        date: { year: 2022, month: 8, day: 4 },
        userName: "Jane",
    },
    {
        nl: "Count all models produced in year 2012",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT COUNT(model) FROM cars WHERE year = 2012",
        queryType: QueryType.WHEREConstAggComparison,
        date: { year: 2022, month: 8, day: 5 },
        userName: "Jane",
    },
    // BY Jack
    {
        nl: "Show all model names of cars produced in year 2020",
        evql: {
            node: { header_names: [], header_aliases: [], foreach: null, projection: { headers: [] }, predicate: { clauses: [] } },
            children: [],
            enforce_t_alias: false,
        },
        sql: "SELECT model FROM cars WHERE year = 2020",
        queryType: QueryType.WHEREScalarComparison,
        date: { year: 2022, month: 7, day: 1 },
        userName: "Jack",
    },
];
