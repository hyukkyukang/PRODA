import { ITableExcerpt } from "../TableExcerpt/TableExcerpt";

// ! This must be aligned with the definition in src/VQA/EVQA.py > Operator
// ! In EVQA, op_type should be index + 1 of below index (0 is reserved for null)
// All the operators
export const operators = ["=", "<", ">", "<=", ">=", "EXISTS", "NOT EXISTS", "IN", "NOT IN", "GROUP", "none", "count", "sum", "avg", "min", "max"];
// Specific types of operators
export const binaryOperators = ["=", "<", ">", "<=", ">=", "IN", "NOT IN"];
export const unaryOperators = ["EXISTS", "NOT EXISTS"];
export const aggFunctions = ["none", "count", "sum", "avg", "min", "max"];

// Interface
export interface Header {
    id: number;
    agg_type: number | null;
}

export interface Projection {
    headers: Header[];
}

export interface Function {
    header_id: number;
    // To identify functions
    func_type: string;
    // For ordering
    is_ascending?: boolean;
    // For Selection
    op_type?: number;
    r_operand?: string;
}

export interface Clause {
    conditions: Function[];
}

export interface Predicate {
    clauses: Clause[];
}

export interface EVQANode {
    name: string;
    table_excerpt: ITableExcerpt;
    headers: string[];
    projection: Projection;
    predicate: Predicate;
}

export interface EVQATree {
    node: EVQANode;
    children: EVQATree[];
}

export interface IEVQAContext {
    evqa: EVQATree;
    setEVQA: React.Dispatch<React.SetStateAction<EVQATree>>;
}
