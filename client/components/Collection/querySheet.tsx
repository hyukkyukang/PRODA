import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import { Box, Grid } from "@mui/material";
import Collapse from "@mui/material/Collapse";
import IconButton from "@mui/material/IconButton";
import React, { useEffect, useMemo, useState } from "react";
import { isEmptyObject } from "../../utils";
import { TableExcerpt } from "../TableExcerpt/TableExcerpt";
import { EVQLTable } from "../VQL/EVQLTable";
import { Task } from "./task";
import { flattenEVQLInPostOrder } from "../VQL/utils";
import { EVQLNode } from "../VQL/EVQL";
import { QueryHistorySheet } from "./queryHistorySheet";

export interface ICoordinateContext {
    selectedCoordinate: { x: number; y: number };
    SetSelectedCoordinate: React.Dispatch<React.SetStateAction<{ x: number; y: number }>>;
}

export const CoordinateContext = React.createContext<ICoordinateContext>({} as ICoordinateContext);

const spanSplicer = (str: string, last_idx: number, start_idx: number, end_idx: number): JSX.Element => {
    return (
        <React.Fragment>
            {last_idx < start_idx ? str.slice(last_idx, start_idx) : null}
            <span className="highlight">{str.slice(start_idx, end_idx)}</span>
        </React.Fragment>
    );
};

export const QuerySheet = (props: { currentTask: Task | null | undefined }) => {
    const { currentTask } = props;
    const [isCollapse, setIsCollapse] = useState<boolean>(true);
    const [selectedCoordinate, SetSelectedCoordinate] = useState<{ x: number; y: number }>({ x: -1, y: -1 });
    const [highlightList, setHighlightList] = useState<Array<[number, number]>>([]);
    const nl_mapping = useMemo(() => currentTask?.nl_mapping, [currentTask]);
    const expandCollapseHandler = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        setIsCollapse(!isCollapse);
    };
    const listOfEVQLNodes = useMemo<EVQLNode[]>(() => (currentTask?.evql ? flattenEVQLInPostOrder(currentTask.evql) : []), [currentTask]);

    const style = {
        transform: isCollapse ? "rotate(180deg)" : "",
        transition: "transform 150ms ease", // smooth transition
    };

    const highlightedNL = (nl: string, highlightIndices: Array<[number, number]>) => {
        let last_idx = 0;
        const list_of_fragments: Array<JSX.Element> = [];
        highlightIndices.forEach((spanIndices: [number, number]) => {
            const tmp = spanSplicer(nl, last_idx, spanIndices[0], spanIndices[1]);
            list_of_fragments.push(tmp);
            last_idx = spanIndices[1];
        });
        // Append last span
        if (nl && last_idx < nl.length) {
            list_of_fragments.push(<span>{nl.slice(last_idx)}</span>);
        }

        return list_of_fragments;
    };

    useEffect(() => {
        if (!isEmptyObject(nl_mapping)) {
            const selectedSpan = nl_mapping?.filter((value) => {
                return value[0] == `${selectedCoordinate.x},${selectedCoordinate.y}`;
            });
            const spanOnly: Array<[number, number]> = selectedSpan ? selectedSpan.map((value) => value.slice(1)) : [];
            setHighlightList(spanOnly);
        }
    }, [nl_mapping, selectedCoordinate]);

    return (
        <React.Fragment>
            {currentTask ? (
                <Box style={{ marginLeft: "15px", marginRight: "15px", paddingTop: "15px" }}>
                    {currentTask.history.map((subTask) => QueryHistorySheet(subTask))}
                    <Collapse in={isCollapse}>
                        <Grid container spacing={2}>
                            <Grid item xs={12} sm={12}>
                                <br />
                                <CoordinateContext.Provider value={{ selectedCoordinate, SetSelectedCoordinate }}>
                                    {currentTask?.tableExcerpt ? <b>Table:</b> : null}
                                    {currentTask?.tableExcerpt ? <TableExcerpt queryResult={currentTask.tableExcerpt} /> : null}
                                    <br />
                                    {currentTask?.evql ? (
                                        <EVQLTable
                                            evqlRoot={{ node: currentTask.evql.node, children: currentTask.evql.children }}
                                            childListPath={[]}
                                            editable={false}
                                            isFirstNode={true}
                                        />
                                    ) : null}
                                </CoordinateContext.Provider>
                                <br />
                                <b>Result Table:</b>
                                <TableExcerpt queryResult={currentTask.resultTable} />
                            </Grid>
                        </Grid>
                        <br />
                    </Collapse>
                    <b>Sentence:</b>
                    <br />
                    <span>{highlightedNL(currentTask?.nl, highlightList)}</span>
                    <div style={{ textAlign: "center" }}>
                        <IconButton onClick={expandCollapseHandler}>
                            <ExpandMoreIcon sx={style} />
                        </IconButton>
                    </div>
                </Box>
            ) : null}
        </React.Fragment>
    );
};

export default QuerySheet;
