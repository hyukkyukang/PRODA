import {removeMultipleSpaces} from '../../utils';

// Operators
export const operators = ["=", "<", ">", "EXISTS", "NOT EXISTS"];
export const binaryOperators = ["=", "<", ">"];
export const uniaryOperators = ["EXISTS", "NOT EXISTS"];
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


// util functions

export const parseExpression = (expression: string, header_names: string[], ignoreWarning=true): Function | null => {
    const cleanExpression = removeMultipleSpaces(expression);
    const literals = cleanExpression.split(" ");
    const tmpCondition: Function = {
        "header_id": -1,
        "func_type": ""
    };
    // If binary operator
    if (literals.length == 3){
        const headerId = header_names.indexOf(literals[0].substring(1, literals[0].length));
        if (headerId == -1){
            if (!ignoreWarning) console.warn("Syntax Error (unexpected header name): " + literals[0]);
            return null;
        }
        tmpCondition.header_id = headerId;
        tmpCondition.r_operand = literals[2];
        tmpCondition.func_type = "Selecting";
        tmpCondition.op_type = operators.indexOf(literals[1])+1;
    }
    // If uniary operator
    else if (literals.length == 2){
        // Check function style input
        const lIdx = cleanExpression.indexOf("(");
        const rIdx = cleanExpression.indexOf(")");
        if (lIdx == -1 || rIdx == -1){
            if (!ignoreWarning) console.warn("Syntax Error (can not find appropriate parenthesis): " + expression);
            return null;
        }
        const funcName = cleanExpression.substring(0, lIdx);
        const funcInput = cleanExpression.substring(lIdx+2, rIdx);
        const headerId = header_names.indexOf(funcInput);
        if (headerId == -1){
            if (!ignoreWarning) console.warn("Syntax Error (unexpected header name): " + funcInput);
            return null;
        }
        tmpCondition.header_id = headerId;
        if (funcName in uniaryOperators) {
            tmpCondition.func_type = "Selecting";
            tmpCondition.op_type = operators.indexOf(funcName)+1;
        }
        else if (funcName == "Group"){
            tmpCondition.func_type = "Grouping";
        }
        else if (funcName in ["Asc", "Des"]){
            tmpCondition.func_type = "Ordering";
            tmpCondition.is_ascending = funcName == "Asc";
        }
        else{
            if (!ignoreWarning) console.warn("Syntax Error (unexpected function name): " + funcName);
            return null;
        }
    }
    else {
        if (!ignoreWarning) console.warn("Syntax Error (can not distinguish operator type): " + expression);
        return null;
    }
    return tmpCondition;
};

export const parseExpressions = (cellValue: string, header_names: string[], ignoreWarning=true): Function[] => {
    const expressions = cellValue.split(" AND ");
    const parsedConditions: Function[] = [];
    for (let i=0; i<expressions.length; i++){
        const expression = expressions[i];
        const tmpCondition = parseExpression(expression, header_names, ignoreWarning);
        if (tmpCondition != null) parsedConditions.push(tmpCondition);
    }
    return parsedConditions;
};


export const conditionToExpression = (condition: Function, names: string[]): string => {
    const l_op = names[condition.header_id];

    if (condition.func_type == "Selecting"){
        if (!condition.op_type) 
        {
            console.error("op_type is not defined");
            return "";
        }
        const op = operators[condition.op_type-1];
        if (binaryOperators.includes(op)){
            return `\$${l_op} ${op} ${condition.r_operand}`;
        }
        else{
            return `\$${op}(${l_op})`;
        }
    }
    else if (condition.func_type == "Grouping") {
        return `Group(\$${l_op})`;
    }
    else if (condition.func_type == "Ordering") {
        return `${condition.is_ascending ? "Asc" : "Des"}(${l_op})`;
    }
    else {
        return `${condition.func_type}(\$${l_op})`;
    }
};
