import { Grid } from "@mui/material";
import Typography from "@mui/material/Typography";
import React, { useEffect, useMemo, useState } from "react";
import { isEmptyObject } from "../../utils";
import { Accordion, AccordionDetails, AccordionSummary } from "../Accordion/customAccordian";
import { TableExcerpt } from "../TableExcerpt/TableExcerpt";
import { EVQATable } from "../VQA/EVQATable";
import { QueryHistorySheet } from "./queryHistorySheet";
import { Task } from "./task";

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
    const [selectedCoordinate, SetSelectedCoordinate] = useState<{ x: number; y: number }>({ x: -1, y: -1 });
    const [highlightList, setHighlightList] = useState<Array<[number, number]>>([]);
    const nl_mapping = useMemo(() => currentTask?.nl_mapping, [currentTask]);
    const reversedSubTaskHistory = useMemo(() => (currentTask?.history ? [...currentTask.history].reverse() : []), [currentTask?.history]);

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
            const spanOnly = selectedSpan ? selectedSpan.map((value) => value.slice(1)) : [];
            setHighlightList(spanOnly as unknown as Array<[number, number]>);
        }
    }, [nl_mapping, selectedCoordinate]);

    return (
        <React.Fragment>
            {currentTask ? (
                <React.Fragment>
                    {reversedSubTaskHistory.map((subTask, subTaskIdx) => (
                        <Accordion>
                            <AccordionSummary aria-controls={`panel${subTaskIdx}a-content`} id={`panel${subTaskIdx}a-header`}>
                                <span>{subTask.evqa.node.name}</span>
                            </AccordionSummary>
                            <AccordionDetails>
                                <QueryHistorySheet task={subTask} />
                            </AccordionDetails>
                        </Accordion>
                    ))}
                    <Accordion>
                        <AccordionSummary aria-controls={`panela-content`} id={`panela-header`}>
                            <span>{currentTask.evqa.node.name}</span>
                        </AccordionSummary>
                        <AccordionDetails>
                            <Grid container spacing={2}>
                                <Grid item xs={12} sm={12}>
                                    <CoordinateContext.Provider value={{ selectedCoordinate, SetSelectedCoordinate }}>
                                        {currentTask?.tableExcerpt ? <h3>Table:</h3> : null}
                                        {currentTask?.tableExcerpt ? <TableExcerpt queryResult={currentTask.tableExcerpt} /> : null}
                                        <br />
                                        {currentTask?.evqa ? (
                                            <EVQATable
                                                evqaRoot={{ node: currentTask.evqa.node, children: currentTask.evqa.children }}
                                                childListPath={[]}
                                                editable={false}
                                                isFirstNode={true}
                                            />
                                        ) : null}
                                    </CoordinateContext.Provider>
                                    <br />
                                    <h3>Result Table:</h3>
                                    <TableExcerpt queryResult={currentTask.resultTable} />
                                </Grid>
                            </Grid>
                            <h2>Sentence:</h2>
                            <Typography variant="body1" gutterBottom>
                                {highlightedNL(currentTask?.nl, highlightList)}
                            </Typography>
                        </AccordionDetails>
                    </Accordion>
                </React.Fragment>
            ) : null}
        </React.Fragment>
    );
};

export default QuerySheet;
