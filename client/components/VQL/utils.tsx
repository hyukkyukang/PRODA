import { EVQLTree, EVQLNode, conditionToExpression, Header, Function } from "./EVQL";
import { createEmptyMatrix, Matrix, CellBase } from "react-spreadsheet-custom";
import { IEVQLTable, IEVQLTableHeader } from "./EVQLTable";
import { isEmptyObject } from "../../utils";

export const createEmptyValueMatrix = (numOfRow: number, numOfCol: number, readOnly?:boolean): Matrix<CellBase> => {
    var rows = createEmptyMatrix<CellBase>(numOfRow, numOfCol);

    for (var i = 0; i < rows.length; i++) {
        for (var j = 0; j < rows[i].length; j++) {
            rows[i][j]={"value": null, "readOnly": Boolean(readOnly)};
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
    for (let i=0; i<numOfCols; i++){
        headers.push({name: evqlNode.header_names[i],
                      aggFuncs: [],
                      isToProject: false});
    }

    // Add info for projection
    evqlNode.projection.headers.forEach((header: Header) => {
        const colId = header.id;
        headers[colId].isToProject = true;
        headers[colId].aggFuncs.push(header.agg_type ? header.agg_type : 0);
    });

    // Create rows if any predicate exists
    if (hasPredicate(evqlNode)){
        for (let i=0; i<evqlNode.predicate.clauses.length; i++){
            for (let j=0; j<evqlNode.predicate.clauses[i].conditions.length; j++){
                const tmpCondition: Function = evqlNode.predicate.clauses[i].conditions[j]
                const newCellValue: string = conditionToExpression(tmpCondition, evqlNode.header_aliases);
                const cell = (tmpCondition.header_id == -1 || tmpCondition.header_id >= numOfCols) ? null : rows[i][tmpCondition.header_id];
                
                if (cell && cell.value){
                    cell.value += " AND " + newCellValue; 
                }
                else if (cell){
                    cell.value = newCellValue;
                }
                else {
                    console.warn(`Bad condition: ${JSON.stringify(tmpCondition)}`);
                }
            }
        }
    }
    return {headers: headers, rows: rows};
};

export const getNode = (evqlTree: EVQLTree, childListIndices: number[] | undefined): EVQLNode => {
    if (childListIndices == undefined || childListIndices.length == 0) return evqlTree.node
    const idx = childListIndices.shift();
    if (idx == undefined) throw 'idx variable is undefined!';
    return getNode(evqlTree.children[idx], childListIndices);
};

export const getTreeTraversingPaths = (evqlTree: EVQLTree, prevPath?: number[]): number[][] => {
    // return paths for every node in the tree (in Post-order)
    if (prevPath == undefined) prevPath = [];

    const pathsToReturn: number[][] = [];
    for (let i=0; i<evqlTree.children.length; i++){
        const child = evqlTree.children[i];
        // Add paths for the child
        pathsToReturn.push(...getTreeTraversingPaths(child, [...prevPath, ...[i]]));
    }
    // Add paths for this node
    pathsToReturn.push(prevPath);
    return pathsToReturn;
};

