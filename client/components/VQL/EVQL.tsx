// Operators
export const operators = ["=", "<", ">", "EXISTS", "NOT EXISTS"];
export const binaryOperators = ["=", "<", ">"];
export const unaryOperators = ["EXISTS", "NOT EXISTS"];
export const aggFunctions = ["none", "count", "sum", "avg", "min", "max"];

// Interface
export interface Header {
    id: number;
    agg_type: number | null;
};

export interface Projection{
    headers: Header[];
};

export interface Function{
    header_id: number;
    // To identify functions
    func_type: string;
    // For ordering
    is_ascending?: boolean;
    // For Selection
    op_type?: number;
    r_operand?: string;
};

export interface Clause{
    conditions: Function[];
};

export interface Predicate{
    clauses: Clause[];
};

export interface EVQLNode {
    header_names: string[];
    header_aliases: string[];
    foreach: number | null;
    projection: Projection;
    predicate: Predicate;
};

export interface EVQLTree {
    node: EVQLNode;
    children: EVQLTree[];
    enforce_t_alias: boolean;
};

export interface IEVQLContext {
    evql: EVQLTree;
    setEVQL: React.Dispatch<React.SetStateAction<EVQLTree>>;
};
