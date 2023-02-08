import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import { Box, Grid } from "@mui/material";
import Collapse from "@mui/material/Collapse";
import IconButton from "@mui/material/IconButton";
import React, { useState } from "react";
import { EVQLTable } from "../VQL/EVQLTable";
import { Task } from "./task";

export const QuerySheet = (props: { currentTask: Task | null }) => {
    const { currentTask } = props;
    const [isCollapse, setIsCollapse] = useState<boolean>(true);

    const expandCollapseHandler = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        setIsCollapse(!isCollapse);
    };

    const style = {
        transform: isCollapse ? "rotate(180deg)" : "",
        transition: "transform 150ms ease", // smooth transition
    };

    return (
        <React.Fragment>
            {currentTask ? (
                <Box style={{ marginLeft: "15px", marginRight: "15px", paddingTop: "15px" }}>
                    <b>Sentence:</b>
                    <br />
                    <span>{currentTask?.nl}</span>
                    <Collapse in={isCollapse}>
                        <br />
                        <Grid container spacing={2}>
                            <Grid item xs={12} sm={12}>
                                <br />
                                <EVQLTable
                                    evqlRoot={{ node: currentTask.evql.node, children: currentTask.evql.children }}
                                    childListPath={[]}
                                    editable={false}
                                    isFirstNode={true}
                                />
                            </Grid>
                        </Grid>
                        <br />
                    </Collapse>
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
