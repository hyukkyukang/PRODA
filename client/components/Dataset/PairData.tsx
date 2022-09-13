import { EVQLTree } from "../VQL/EVQL";

export interface IDate {
    year: number;
    month: number;
    day: number;
}

export const queryTypeNames: { [key: string]: string } = {
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

// Change the name. PairData may be misleading
export interface IPairData {
    nl: string;
    evql: EVQLTree;
    sql: string;
    queryType: string;
    dbName: string;
    tableExcerpt: any[];
}

export interface ILogData {
    userName: string;
    dbName: string;
    nl: string;
    sql: string;
    evql: EVQLTree;
    queryType: string;
    date: IDate;
    user_nl: string;
    user_isCorrect: boolean;
}

export const dateToString = (date: IDate): string => {
    return `${date.year}.${date.month}.${date.day}`;
};

export const stringToDate = (dateString: string): IDate => {
    const [year, month, day] = dateString.split(".");
    return { year: parseInt(year), month: parseInt(month), day: parseInt(day) };
};

export const isGreaterThan = (date1: IDate, date2: IDate): boolean => {
    if (date1.year > date2.year) return true;
    if (date1.year < date2.year) return false;
    if (date1.month > date2.month) return true;
    if (date1.month < date2.month) return false;
    if (date1.day > date2.day) return true;
    if (date1.day < date2.day) return false;
    return false;
};
