import React, { useMemo } from "react";
import Tree from "react-d3-tree";
import { EVQATree } from "../VQA/EVQA";

const description = "Below is the task...";

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
    const translate = { x: treeBreadth * 100, y: level * 50 };
    return (
        <div>
            <p style={{ textAlign: "center" }}>Query Tree</p>
            <Tree
                data={data}
                rootNodeClassName="node__root"
                branchNodeClassName="node__branch"
                leafNodeClassName="node__leaf"
                orientation="vertical"
                translate={translate}
                draggable={true}
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

export const TaskDescription = (props: { evqa: EVQATree | null | undefined }) => {
    const { evqa } = props;
    const treeData = useMemo<RawNodeDatum | null>(() => (evqa ? convertTaskToTreeData(evqa) : null), [evqa]);
    const treeLevel = useMemo<number>(() => (evqa ? getLevel(evqa) : 0), [evqa]);
    const treeBreadth = useMemo<number>(() => (evqa ? getWidth(evqa) : 0), [evqa]);
    const height = useMemo<number>(() => treeLevel * 150, [treeLevel]);

    console.log(`treelevel: ${treeLevel}, heigth:${height}`);

    return (
        <React.Fragment>
            <div style={{ height: `${height}px` }}>
                <div style={{ display: "inline", paddingLeft: "10px" }}>
                    <div style={{ display: "inline-block", width: "40%", verticalAlign: "top", marginTop: "10px" }}>
                        <p>{description}</p>
                    </div>
                    {treeData ? <div style={{ display: "inline-block", width: "40%" }}>{getQueryTree(treeData, treeBreadth, treeLevel)}</div> : null}
                </div>
            </div>
        </React.Fragment>
    );
};
