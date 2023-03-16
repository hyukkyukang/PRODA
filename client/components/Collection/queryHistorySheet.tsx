import { useState } from "react";
import { Task } from "./task";
import { TableExcerpt } from "../TableExcerpt/TableExcerpt";
import { EVQLTable } from "../VQL/EVQLTable";

export const QueryHistorySheet = (task: Task) => {
    const evqlTree = task.evql;
    const evqlNode = evqlTree.node;

    const [isHidden, setIsHidden] = useState<boolean>(true);

    return (
        <div>
            <button onClick={() => setIsHidden(!isHidden)}>{evqlNode.name}</button>
            {isHidden ? null : (
                <>
                    <br />
                    {/* Table */}
                    <b>Table</b>
                    <br />
                    <TableExcerpt queryResult={task.resultTable}></TableExcerpt>
                    {/* EVQA */}
                    <EVQLTable evqlRoot={evqlTree} childListPath={[]} editable={false} isFirstNode={true} />
                    {/* Description */}
                    <b>Description</b>
                    <br />
                    {task.nl}
                    {/* Result */}
                    <b>Result</b>
                    <br />
                    <TableExcerpt queryResult={task.resultTable} />
                </>
            )}
            <br />
        </div>
    );
};
