import React, { useMemo } from "react";
import Tree from "react-d3-tree";
import { EVQLTree } from "../VQL/EVQL";

const description = "Below is the task...";

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

export const TaskDescription = (props: { evql: EVQLTree | null | undefined }) => {
    const { evql } = props;
    const treeData = useMemo<RawNodeDatum | null>(() => (evql ? convertTaskToTreeData(evql) : null), [evql]);
    const treeLevel = useMemo<number>(() => (evql ? getLevel(evql) : 0), [evql]);
    const treeBreadth = useMemo<number>(() => (evql ? getWidth(evql) : 0), [evql]);
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
