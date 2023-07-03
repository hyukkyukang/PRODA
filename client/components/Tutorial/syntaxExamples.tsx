import React from "react";
import { CellBase } from "react-spreadsheet-custom";
import { IEVQATable } from "../VQA/EVQATable";
import { aggFunctions } from "../VQA/EVQA";

export const valueToCell = (value: React.ReactElement): CellBase => {
    return { value: value, readOnly: true };
};

export const stringToReactElement = (value: string): React.ReactElement => {
    return (
        <div style={{ justifyContent: "center", textAlign: "center" }}>
            <i> {value} </i>
        </div>
    );
};

export const ProjectionSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: true },
        { name: "column2", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "", "", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const MinMaxSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [aggFunctions.indexOf("min")], limitNum: 0, isToProject: true },
        { name: "column2", aggFuncs: [aggFunctions.indexOf("max")], limitNum: 0, isToProject: true },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "", "", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const CountAvgSumSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [aggFunctions.indexOf("count")], limitNum: 0, isToProject: true },
        { name: "column2", aggFuncs: [aggFunctions.indexOf("avg")], limitNum: 0, isToProject: true },
        { name: "column3", aggFuncs: [aggFunctions.indexOf("sum")], limitNum: 0, isToProject: true },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "", "", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const SelectionSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column2", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "condition", "", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const SelectionOrSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column2", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [
        ["", "condition1", "", "", ""].map(stringToReactElement).map(valueToCell),
        ["", "", "condition2", "", ""].map(stringToReactElement).map(valueToCell),
    ],
};

export const SelectionAndSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column2", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "condition1", "condition2", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const GroupingSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column2", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "", "Group($column2)", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const OrderingSyntaxExample: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: false },
        { name: "column2", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [["", "Asc($column1)", "", "", ""].map(stringToReactElement).map(valueToCell)],
};

export const HavingSyntaxExampleStep1: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: true },
        { name: "column2", aggFuncs: [aggFunctions.indexOf("count")], limitNum: 0, isToProject: true },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [],
};

export const HavingSyntaxExampleStep2: IEVQATable = {
    headers: [
        { name: "table_name", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "column1", aggFuncs: [0], limitNum: 0, isToProject: true },
        { name: "column2", aggFuncs: [aggFunctions.indexOf("count")], limitNum: 0, isToProject: true },
        { name: "column3", aggFuncs: [], limitNum: 0, isToProject: false },
        { name: "...", aggFuncs: [], limitNum: 0, isToProject: false },
    ],
    rows: [],
};
