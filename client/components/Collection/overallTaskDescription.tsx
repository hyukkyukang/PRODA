import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import Link from "next/link";
import React, { useMemo } from "react";
import Tree from "react-d3-tree";
import { EVQATree } from "../VQA/EVQA";

export interface RawNodeDatum {
    name: string;
    attributes?: Record<string, string | number | boolean>;
    children?: RawNodeDatum[];
}

const convertTaskToTreeData = (evqa: EVQATree): RawNodeDatum => {
    return {
        name: evqa.node.name,
        children: evqa.children.map((child) => convertTaskToTreeData(child)),
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

const getWidth = (evqa: EVQATree): number => {
    if (evqa.children.length == 0) {
        return 1;
    }
    return evqa.children.reduce((acc, child) => acc + getWidth(child as EVQATree), 0);
};

const getLevel = (evqa: EVQATree): number => {
    if (evqa.children.length == 0) {
        return 1;
    }
    const listOfLevels = evqa.children.map((child) => getLevel(child as EVQATree));
    return Math.max(...listOfLevels) + 1;
};

export const OverallTaskDescription = (props: { evqa: EVQATree | null | undefined }) => {
    const { evqa } = props;
    const treeData = useMemo<RawNodeDatum | null>(() => (evqa ? convertTaskToTreeData(evqa) : null), [evqa]);
    const treeLevel = useMemo<number>(() => (evqa ? getLevel(evqa) : 0), [evqa]);
    const treeBreadth = useMemo<number>(() => (evqa ? getWidth(evqa) : 0), [evqa]);
    const height = useMemo<number>(() => treeLevel * 150, [treeLevel]);

    return (
        <React.Fragment>
            <Grid container>
                <Grid item xs={6} sx={{ margin: "10px", marginLeft: "18px" }}>
                    <h1>Instruction</h1>
                    {/* <Box sx={{ fontWeight: "regular", m: 1, fontSize: "18px", textAlign: "justify", whiteSpace: "pre-line" }}>{instructionText}</Box> */}
                    <Typography sx={{ textAlign: "justify", whiteSpace: "pre-line" }}>
                        We have presented one or more EVQA blocks below, along with a visual representation on the right that illustrates the link between
                        individual EVQA blocks (the output of the child block serves as input for the parent block). Please thoroughly review the following
                        EVQA, and evaluate whether the concluding statement at the bottom of the page provides an accurate summary of the entire process. You
                        may refer to the{" "}
                        <Link href="/tutorial" target="_blank">
                            tutorial page
                        </Link>{" "}
                        as needed.
                    </Typography>
                </Grid>
                <Grid item xs={5}>
                    {treeData ? getQueryTree(treeData, treeBreadth, treeLevel) : null}
                </Grid>
            </Grid>
        </React.Fragment>
    );
};

export default OverallTaskDescription;
