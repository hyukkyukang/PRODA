import { CellBase, createEmptyMatrix, Matrix } from "react-spreadsheet-custom";
import { isArrayEqual, isEmptyObject, isNumber, removeMultipleSpaces, stripQutations } from "../../utils";
import { aggFunctions, binaryOperators, EVQLNode, EVQLTree, Function, Header, operators, unaryOperators } from "./EVQL";
import { IEVQLTable, IEVQLTableHeader } from "./EVQLTable";
import { operatorDescriptions } from "./operatorDescriptions";

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
    // Handle exception
    if (isEmptyObject(evqlNode)) {
        console.warn(`evqlNode empty when calling EVQLNodeToEVQLTable`);
        return {} as IEVQLTable;
    }
    if (isEmptyObject(evqlNode.headers)) {
        console.warn(`evqlNode does not have headers..`);
        return {} as IEVQLTable;
    }
    const hasPredicate = (node: EVQLNode): boolean => {
        return !isEmptyObject(node.predicate) && !isEmptyObject(node.predicate.clauses);
    };
    const numOfRows = hasPredicate(evqlNode) ? evqlNode.predicate.clauses.length : 1;
    const numOfCols = evqlNode.headers.length;
    var headers: IEVQLTableHeader[] = [];
    var rows = createEmptyValueMatrix(numOfRows, numOfCols, !editable);

    // Create default headers
    for (let i = 0; i < numOfCols; i++) {
        headers.push({ name: evqlNode.headers[i], aggFuncs: [], isToProject: false });
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
                const newCellValue: string = conditionToExpression(tmpCondition, evqlNode.headers);
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
    return getSubtree(evqlTree, childListIndices).node;
};

export const getSubtree = (evqlTree: EVQLTree, childListIndices: number[] | undefined): EVQLTree => {
    if (childListIndices == undefined || childListIndices.length == 0) return evqlTree;
    const idx = childListIndices.shift();
    if (idx == undefined) throw "idx variable is undefined!";
    return getSubtree(evqlTree.children[idx], childListIndices);
};

export const getTreeTraversingPaths = (evqlTree: EVQLTree, prevPath?: number[]): number[][] => {
    // return paths for every node in the tree (in Post-order)
    if (isEmptyObject(evqlTree)) return [];
    if (prevPath == undefined) prevPath = [];

    const pathsToReturn: number[][] = [];
    if (evqlTree.children) {
        for (let i = 0; i < evqlTree.children.length; i++) {
            const child = evqlTree.children[i];
            // Add paths for the child
            pathsToReturn.push(...getTreeTraversingPaths(child, [...prevPath, ...[i]]));
        }
        // Add paths for this node
        pathsToReturn.push(prevPath);
    }
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
    // If unary or functional operator
    else if (literals.length == 1) {
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
            // Parse right operand
            var r_op;
            if (isEmptyObject(condition.r_operand)) {
                r_op = "";
            } else if (isNumber(condition.r_operand)) {
                r_op = condition.r_operand;
            } else if (condition.r_operand?.startsWith("$")) {
                r_op = `$${names[parseInt(condition.r_operand.substring(1))]}`;
            } else {
                r_op = `"${condition.r_operand}"`;
            }
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
    // TODO: Need to get result table from the previous query and make a new table excerpt
    const newNode: EVQLNode = {
        name: "dummy_name",
        table_excerpt: {
            name: "new_node",
            headers: [...newHeaders],
            col_types: [],
            rows: [],
            base_table_names: [],
        },
        headers: [...newHeaders],
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
        const newColName = prefix + evql.headers[header.id];
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

export const getCellDescription = (expressions: Function[]): string => {
    const descriptions: Array<string | undefined> = expressions.map((expression) => {
        if (expression.func_type == "Selecting") {
            const op_type: number = expression?.op_type ? expression.op_type : 0;
            const op_type_str: string = operators[op_type - 1];
            if (Object.keys(operatorDescriptions).includes(op_type_str)) {
                return operatorDescriptions[op_type_str as keyof typeof operatorDescriptions];
            } else {
                return "";
            }
        } else if (expression.func_type == "Grouping") {
            return operatorDescriptions["Group"];
        } else if (expression.func_type == "Ordering") {
            return operatorDescriptions["Order"];
        }
    });
    const filterEmptyString = (str: string | undefined) => str != "" && str != undefined;
    const filteredDescriptions = descriptions.filter(filterEmptyString);
    return filteredDescriptions.join("\n");
};

export const getHeaderDescription = (header: IEVQLTableHeader): string => {
    const descriptions: Array<string | undefined> = [];
    if (header.isToProject) {
        descriptions.push("Highlighted header indicates that the corresponding column has been chosen to be displayed in the output.");
    }
    header.aggFuncs.forEach((aggFunc) => {
        const aggFuncStr = aggFunctions[aggFunc];
        descriptions.push(operatorDescriptions[aggFuncStr as keyof typeof operatorDescriptions]);
    });
    return descriptions.join("\n");
};

export const flattenEVQLInPostOrder = (evqlTree: EVQLTree): EVQLNode[] => {
    const flattenedEVQL: EVQLNode[] = [];
    const traverse = (evqlTree: EVQLTree) => {
        evqlTree.children.forEach((child) => traverse(child));
        flattenedEVQL.push(evqlTree.node);
    };
    traverse(evqlTree);
    return flattenedEVQL;
};
