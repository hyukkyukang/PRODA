import { EVQLTree, EVQLNode, Header, Function, operators, unaryOperators, binaryOperators, aggFunctions } from "./EVQL";
import { createEmptyMatrix, Matrix, CellBase } from "react-spreadsheet-custom";
import { IEVQLTable, IEVQLTableHeader } from "./EVQLTable";
import { isEmptyObject, removeMultipleSpaces, isNumber, stripQutations, isArrayEqual } from "../../utils";

export const createEmptyValueMatrix = (numOfRow: number, numOfCol: number, readOnly?: boolean): Matrix<CellBase> => {
    var rows = createEmptyMatrix<CellBase>(numOfRow, numOfCol);

    for (var i = 0; i < rows.length; i++) {
        for (var j = 0; j < rows[i].length; j++) {
            rows[i][j] = { value: null, readOnly: Boolean(readOnly) };
        }
    }
    return rows;
};

export const EVQLNodeToEVQLTable = (evqlNode: EVQLNode, editable: boolean): IEVQLTable => {
    const hasPredicate = (node: EVQLNode): boolean => {
        return !isEmptyObject(node.predicate) && !isEmptyObject(node.predicate.clauses);
    };
    const numOfRows = hasPredicate(evqlNode) ? evqlNode.predicate.clauses.length : 1;
    const numOfCols = evqlNode.header_names.length;
    var headers: IEVQLTableHeader[] = [];
    var rows = createEmptyValueMatrix(numOfRows, numOfCols, !editable);

    // Create default headers
    for (let i = 0; i < numOfCols; i++) {
        headers.push({ name: evqlNode.header_names[i], aggFuncs: [], isToProject: false });
    }

    // Add info for projection
    evqlNode.projection.headers.forEach((header: Header) => {
        const colId = header.id;
        headers[colId].isToProject = true;
        headers[colId].aggFuncs.push(header.agg_type ? header.agg_type : 0);
    });

    // Create rows if any predicate exists
    if (hasPredicate(evqlNode)) {
        for (let i = 0; i < evqlNode.predicate.clauses.length; i++) {
            for (let j = 0; j < evqlNode.predicate.clauses[i].conditions.length; j++) {
                const tmpCondition: Function = evqlNode.predicate.clauses[i].conditions[j];
                const newCellValue: string = conditionToExpression(tmpCondition, evqlNode.header_aliases);
                const cell = tmpCondition.header_id == -1 || tmpCondition.header_id >= numOfCols ? null : rows[i][tmpCondition.header_id];

                if (cell && cell.value) {
                    cell.value += " AND " + newCellValue;
                } else if (cell) {
                    cell.value = newCellValue;
                } else {
                    console.warn(`Bad condition: ${JSON.stringify(tmpCondition)}`);
                }
            }
        }
    }
    return { headers: headers, rows: rows };
};

export const getNode = (evqlTree: EVQLTree, childListIndices: number[] | undefined): EVQLNode => {
    if (childListIndices == undefined || childListIndices.length == 0) return evqlTree.node;
    const idx = childListIndices.shift();
    if (idx == undefined) throw "idx variable is undefined!";
    return getNode(evqlTree.children[idx], childListIndices);
};

export const getTreeTraversingPaths = (evqlTree: EVQLTree, prevPath?: number[]): number[][] => {
    // return paths for every node in the tree (in Post-order)
    if (isEmptyObject(evqlTree)) return [];
    if (prevPath == undefined) prevPath = [];

    const pathsToReturn: number[][] = [];
    for (let i = 0; i < evqlTree.children.length; i++) {
        const child = evqlTree.children[i];
        // Add paths for the child
        pathsToReturn.push(...getTreeTraversingPaths(child, [...prevPath, ...[i]]));
    }
    // Add paths for this node
    pathsToReturn.push(prevPath);
    return pathsToReturn;
};

export const parseExpression = (expression: string, header_names: string[], ignoreWarning = true): Function | null => {
    const cleanExpression = removeMultipleSpaces(expression);
    const literals = cleanExpression.split(" ");
    const tmpCondition: Function = {
        header_id: -1,
        func_type: "",
    };
    // If binary operator
    if (literals.length == 3) {
        const headerId = header_names.indexOf(literals[0].substring(1, literals[0].length));
        if (headerId == -1) {
            if (!ignoreWarning) console.warn("Syntax Error (unexpected header name): " + literals[0]);
            return null;
        }
        tmpCondition.header_id = headerId;
        tmpCondition.r_operand = stripQutations(literals[2]);
        tmpCondition.func_type = "Selecting";
        tmpCondition.op_type = operators.indexOf(literals[1]) + 1;
    }
    // If unary operator
    else if (literals.length == 2) {
        // Check function style input
        const lIdx = cleanExpression.indexOf("(");
        const rIdx = cleanExpression.indexOf(")");
        if (lIdx == -1 || rIdx == -1) {
            if (!ignoreWarning) console.warn("Syntax Error (can not find appropriate parenthesis): " + expression);
            return null;
        }
        const funcName = cleanExpression.substring(0, lIdx);
        const funcInput = cleanExpression.substring(lIdx + 2, rIdx);
        const headerId = header_names.indexOf(funcInput);
        if (headerId == -1) {
            if (!ignoreWarning) console.warn("Syntax Error (unexpected header name): " + funcInput);
            return null;
        }
        tmpCondition.header_id = headerId;
        if (funcName in unaryOperators) {
            tmpCondition.func_type = "Selecting";
            tmpCondition.op_type = operators.indexOf(funcName) + 1;
        } else if (funcName == "Group") {
            tmpCondition.func_type = "Grouping";
        } else if (funcName in ["Asc", "Des"]) {
            tmpCondition.func_type = "Ordering";
            tmpCondition.is_ascending = funcName == "Asc";
        } else {
            if (!ignoreWarning) console.warn("Syntax Error (unexpected function name): " + funcName);
            return null;
        }
    } else {
        if (!ignoreWarning) console.warn("Syntax Error (can not distinguish operator type): " + expression);
        return null;
    }
    return tmpCondition;
};

export const parseExpressions = (cellValue: string, header_names: string[], ignoreWarning = true): Function[] => {
    const expressions = cellValue.split(" AND ");
    const parsedConditions: Function[] = [];
    for (let i = 0; i < expressions.length; i++) {
        const expression = expressions[i];
        const tmpCondition = parseExpression(expression, header_names, ignoreWarning);
        if (tmpCondition != null) parsedConditions.push(tmpCondition);
    }
    return parsedConditions;
};

export const conditionToExpression = (condition: Function, names: string[]): string => {
    const l_op = names[condition.header_id];

    if (condition.func_type == "Selecting") {
        if (!condition.op_type) {
            console.error("op_type is not defined");
            return "";
        }
        const op = operators[condition.op_type - 1];
        if (binaryOperators.includes(op)) {
            const tmp = condition?.r_operand ? condition.r_operand : "";
            const r_op = isNumber(tmp) || tmp.startsWith("$") ? tmp : `"${tmp}"`;
            return `\$${l_op} ${op} ${r_op}`;
        } else {
            return `${op}($${l_op})`;
        }
    } else if (condition.func_type == "Grouping") {
        return `Group($${l_op})`;
    } else if (condition.func_type == "Ordering") {
        return `${condition.is_ascending ? "Asc" : "Des"}($${l_op})`;
    } else {
        return `${condition.func_type}($${l_op})`;
    }
};

export const addEVQLNode = (evqlTree: EVQLTree, newHeaders: string[]): EVQLTree => {
    // Create new evql node
    // TODO: modify header_names if necessary in the parent node
    const newNode: EVQLNode = {
        header_names: [...newHeaders],
        header_aliases: [...newHeaders],
        foreach: null,
        projection: {
            headers: [],
        },
        predicate: {
            clauses: [],
        },
    };

    // Add new node to the tree
    const newTree: EVQLTree = {
        node: newNode,
        children: [evqlTree],
        enforce_t_alias: false,
    };

    return newTree;
};

export const getProjectedNames = (evqlTree: EVQLTree, childListPath: number[]): string[] => {
    const evql: EVQLNode = getNode(evqlTree, [...childListPath]);
    const projectedNames: string[] = [];

    // Get all childListPaths
    const childListPaths = getTreeTraversingPaths(evqlTree);

    // Find queryStep
    var queryStep = -1;
    for (var i = 0; i < childListPaths.length; i++) {
        if (isArrayEqual(childListPaths[i], childListPath)) {
            queryStep = i;
        }
    }
    // Handle error
    if (queryStep == -1) {
        console.error("Can not find queryStep");
        return [];
    }

    const prefix = `step${queryStep + 1}_`;
    evql.projection.headers.forEach((header) => {
        const newColName = prefix + evql.header_names[header.id];
        if (header.agg_type === aggFunctions.indexOf("count")) {
            projectedNames.push(`${newColName}_count`);
        } else if (header.agg_type === aggFunctions.indexOf("sum")) {
            projectedNames.push(`${newColName}_sum`);
        } else if (header.agg_type === aggFunctions.indexOf("avg")) {
            projectedNames.push(`${newColName}_avg`);
        } else if (header.agg_type === aggFunctions.indexOf("min")) {
            projectedNames.push(`${newColName}_min`);
        } else if (header.agg_type === aggFunctions.indexOf("max")) {
            projectedNames.push(`${newColName}_max`);
        } else {
            projectedNames.push(newColName);
        }
    });
    return projectedNames;
};
