import React, { useMemo } from "react";
import Tree from "react-d3-tree";
import { EVQLTree } from "../VQL/EVQL";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";

const instructionText =
    "Below, we provide one or more blocks of table and EVQA where the EVQA describes an operation on each table. On the right is a visual representation that describes the connection between individual EVQA blocks. The result of the child block is used as an input to the parent block. Please carefully review the following EVQA and see if the statement at the bottom of the page accurately summarizes the entire process.";

export interface RawNodeDatum {
    name: string;
    attributes?: Record<string, string | number | boolean>;
    children?: RawNodeDatum[];
}

const convertTaskToTreeData = (evql: EVQLTree): RawNodeDatum => {
    return {
        name: evql.node.name,
        children: evql.children.map((child) => convertTaskToTreeData(child)),
    };
};

const getQueryTree = (data: RawNodeDatum, treeBreadth: number, level: number) => {
    const translate = { x: treeBreadth * 130, y: level * 20 };
    return (
        <div style={{ height: `${level * 130}px` }}>
            {/* <p style={{ textAlign: "center" }}>Query Tree</p> */}
            <h2 style={{ marginTop: "10px", textAlign: "center" }}>Visual Representation of Operation Blocks</h2>
            <Tree
                data={data}
                rootNodeClassName="node__root"
                branchNodeClassName="node__branch"
                leafNodeClassName="node__leaf"
                orientation="vertical"
                translate={translate}
                draggable={false}
                zoomable={false}
                zoom={0.9}
                pathFunc="step"
            />
        </div>
    );
};

const getWidth = (evql: EVQLTree): number => {
    if (evql.children.length == 0) {
        return 1;
    }
    return evql.children.reduce((acc, child) => acc + getWidth(child as EVQLTree), 0);
};

const getLevel = (evql: EVQLTree): number => {
    if (evql.children.length == 0) {
        return 1;
    }
    const listOfLevels = evql.children.map((child) => getLevel(child as EVQLTree));
    return Math.max(...listOfLevels) + 1;
};

export const OverallTaskDescription = (props: { evql: EVQLTree | null | undefined }) => {
    const { evql } = props;
    const treeData = useMemo<RawNodeDatum | null>(() => (evql ? convertTaskToTreeData(evql) : null), [evql]);
    const treeLevel = useMemo<number>(() => (evql ? getLevel(evql) : 0), [evql]);
    const treeBreadth = useMemo<number>(() => (evql ? getWidth(evql) : 0), [evql]);
    const height = useMemo<number>(() => treeLevel * 150, [treeLevel]);

    return (
        <React.Fragment>
            <Grid container>
                <Grid item xs={6} sx={{ margin: "10px", marginLeft: "18px" }}>
                    <h1>Instruction</h1>
                    {/* <Box sx={{ fontWeight: "regular", m: 1, fontSize: "18px", textAlign: "justify", whiteSpace: "pre-line" }}>{instructionText}</Box> */}
                    <Typography sx={{ textAlign: "justify", whiteSpace: "pre-line" }}>{instructionText}</Typography>
                </Grid>
                <Grid item xs={5}>
                    {treeData ? getQueryTree(treeData, treeBreadth, treeLevel) : null}
                </Grid>
            </Grid>
        </React.Fragment>
    );
};

export default OverallTaskDescription;
