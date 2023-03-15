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
