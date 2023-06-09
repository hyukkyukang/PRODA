<<<<<<< HEAD
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
=======
import Typography from "@mui/material/Typography";
import React, { useMemo } from "react";
import { TableExcerpt } from "../TableExcerpt/TableExcerpt";
import { EVQLTable } from "../VQL/EVQLTable";
import { Task } from "./task";

export const QueryHistorySheet = (props: { task: Task }) => {
    const { task } = props;
    const evqlTree = useMemo(() => task?.evql, [task]);

    return (
        <React.Fragment>
            {/* Table */}
            <h3>Table:</h3>
            <TableExcerpt queryResult={task.resultTable}></TableExcerpt>
            {/* EVQA */}
            <EVQLTable evqlRoot={evqlTree} childListPath={[]} editable={false} isFirstNode={true} />
            <br />
            {/* Description */}
            <h3>Description:</h3>
            <Typography variant="body1" gutterBottom>
                {task.nl}
            </Typography>
            <br />
            {/* Result */}
            <h3>Result:</h3>
            <TableExcerpt queryResult={task.resultTable} />
        </React.Fragment>
    );
};

export default QueryHistorySheet;
>>>>>>> 3852206c33520deb109d3f8ae41a25238b1d87ba
