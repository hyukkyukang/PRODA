import React, { useEffect, useMemo } from 'react';
import { Container, Button, TextField, Select, MenuItem, Grid, SelectChangeEvent, FormControl, InputAdornment, InputLabel, OutlinedInput } from '@mui/material';

import { EVQLTree, EVQLNode, Function, Header, parseExpression, conditionToExpression } from "./EVQL";
import { Coordinate } from "./EVQLTable";
import { getNode } from "./utils";
import { isEmptyObject } from "../../utils";

import { AiFillPlusSquare, AiFillCloseCircle } from "react-icons/ai";
import { IoMdRemoveCircleOutline } from "react-icons/io";

export interface ISideBar {
    evqlRoot: EVQLTree;
    setEVQL: React.Dispatch<React.SetStateAction<EVQLTree>>;
    selectedCoordinate: Coordinate | undefined;
    showSideBar: boolean;
    setShowSideBar: React.Dispatch<React.SetStateAction<boolean>>;
};

// Helper functions
const isNothingSelected = (coordinate: Coordinate | undefined): boolean => {
    return !coordinate || (coordinate.colIdx === -1 && coordinate.rowIdx === -1);
};
const isHeaderSelected = (coordinate: Coordinate | undefined): boolean => {
    return !isNothingSelected(coordinate) && (coordinate?.colIdx !== -1 && coordinate?.rowIdx === -1);
};
const isCellSelected = (coordinate: Coordinate | undefined): boolean => {
    return !isNothingSelected(coordinate) && (coordinate?.colIdx !== -1 && coordinate?.rowIdx !== -1);
};

// CSS Styles
const buttonStyle = {color: "black", background: "#f5f6f7", borderWidth: "0"};

// JSX Elements
const sideBarHeader = (title: string, closeButtonHandler: React.MouseEventHandler<HTMLButtonElement>): JSX.Element => {
    return (<Grid container style={{marginTop: "5px"}} justifyContent="flex-end">
        <Grid item xs={10} style={{marginLeft: "10px"}}>
            <h3>{title}</h3>
        </Grid>
        <Grid item xs={1.5}>
        <button onClick={closeButtonHandler} style={{marginTop: "10px", background: "#f5f6f7", borderWidth: "0"}}>
            <AiFillCloseCircle size={20} style={{color: "black"}}/>
        </button>
        </Grid>
    </Grid>);
};
const doneButton = (onClickHandler: React.MouseEventHandler<HTMLButtonElement>): JSX.Element => (<>
    <Container sx={{textAlign: "center"}}>
    <br/>
    <br/>
    <Button variant="contained" color="success" size="medium" onClick={onClickHandler}>{"Done"} </Button>
    </Container>
</>);

interface IExpressionData {
    colIdx: number;
    expression: string;
};

export const SideBar = (props: ISideBar) => {
    const {evqlRoot, setEVQL, showSideBar, selectedCoordinate, setShowSideBar} = props;

    // Local variables
    const selectedEVQLNode: EVQLNode = useMemo(() => getNode(evqlRoot, selectedCoordinate?.tableIndices), [evqlRoot, selectedCoordinate]);
    const selectedHeaders = useMemo(() => selectedEVQLNode?.projection.headers, [selectedEVQLNode, evqlRoot]);
    const selectedClauses = useMemo(() => selectedEVQLNode?.predicate.clauses, [selectedEVQLNode, evqlRoot]);
    const selectedConditions = useMemo(() => !isEmptyObject(selectedClauses) && selectedCoordinate && isCellSelected(selectedCoordinate) ? selectedClauses[selectedCoordinate.rowIdx].conditions : null, [selectedClauses, selectedCoordinate]);
    const selectedHeaderName = useMemo(() => selectedEVQLNode && selectedCoordinate ? selectedEVQLNode.header_names[selectedCoordinate.colIdx] : "", [selectedCoordinate, selectedEVQLNode, evqlRoot]);
    const startAdornment = useMemo(() => `\$${selectedHeaderName} `, [selectedHeaderName]);
    const [selectedExpressions, setSelectedExpressions] = React.useState<IExpressionData[]>([]);
    
    // Helper functions
    const closeSideBarHandler: React.MouseEventHandler<HTMLButtonElement> = () => {
        setShowSideBar(false);
    };

    // Projection Handlers
    const addProjectionHandler = () => {
        if (selectedCoordinate == undefined) return;
        // If Projection headers of this colId is less than 4, add a new projection
        const numOfProjectionForSelectedCol = selectedEVQLNode?.projection.headers.filter(header => header.id == selectedCoordinate.colIdx).length;
        if (numOfProjectionForSelectedCol < 5) {
            selectedEVQLNode?.projection.headers.push({"id":selectedCoordinate.colIdx, "agg_type":null});
            setEVQL(Object.assign({}, evqlRoot));
        }
    };

    const removeProjectionHandler = (idx: number) => {
        selectedEVQLNode?.projection.headers.splice(idx, 1);
        setEVQL(Object.assign({}, evqlRoot));
    };

    const modifyAggTypeHandler = (idx: number, event: SelectChangeEvent<number>) => {
        // Set aggregation function to "idx" element;
        const value: number | string = event?.target?.value;
        const aggType: number = typeof value == "number" ? value : parseInt(value);
        selectedEVQLNode.projection.headers[idx]["agg_type"] = aggType;
        setEVQL(Object.assign({}, evqlRoot));
    };

    // Condition Handlers
    const addConditionHandler = (event: React.MouseEvent<HTMLButtonElement>) => {
        if (!selectedCoordinate) return ;
        setSelectedExpressions([...selectedExpressions, {colIdx: selectedCoordinate.colIdx, expression: ""}]);
    };

    const modifyExpressionHandler = (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>, idx: number) => {
        selectedExpressions[idx].expression = `${startAdornment} ${event.target.value.replace("  ", " ")}`;
        setSelectedExpressions([...selectedExpressions]);
    };

    const removeConditionHandler = (idx: number) => {
        selectedExpressions?.splice(idx, 1);
        setSelectedExpressions([...selectedExpressions]);
    };

    const closeConditionBuilderHandler = () => {
        /* Clear conditions and add them back with parsed expreessions */
        const conditionArrayToUse = selectedConditions ? selectedConditions : [];
        // Push new condition array
        if (!selectedConditions){
            selectedClauses.push({conditions: conditionArrayToUse});
        }
        // Clear condition array. 
        conditionArrayToUse.length = 0;
        // Parse expression
        selectedExpressions.forEach(expressionData => {
            const newcondition = parseExpression(expressionData.expression, selectedEVQLNode.header_names);
            // If successfully parsed, add it to the condition array
            if (newcondition) conditionArrayToUse.push(newcondition);
        });
        // Update states
        setEVQL(Object.assign({}, evqlRoot));
        setShowSideBar(false);
    };

    // Main Elements
    const projectionBuilder = 
        <>
            {sideBarHeader("Projection Builder", closeSideBarHandler)}
            <div style={{...{marginTop: "10px", marginLeft: "10px"}, ...buttonStyle}}>
                    <p style={{marginLeft: "10px"}}>{selectedCoordinate && selectedCoordinate.colIdx == 0 ? "Table:": "Column:"} {selectedHeaderName}</p>
                    {selectedHeaders ? selectedHeaders.map((header: Header, idx: number) => (
                            header.id != selectedCoordinate?.colIdx ? null :
                            <div key={idx} style={{margin: "10px"}}>
                            <button style={buttonStyle}>
                                <IoMdRemoveCircleOutline size={20} onClick={e => removeProjectionHandler(idx)}/>
                            </button>
                            <Select id={String(idx)} onChange={e => modifyAggTypeHandler(idx, e)}
                                    value={header.agg_type ?? 0} displayEmpty inputProps={{'aria-label': 'Without label'}}
                                    style={{width: "100px"}}>
                                <MenuItem value={0}><em>None</em></MenuItem>
                                <MenuItem value={1}>Count</MenuItem>
                                {selectedCoordinate.colIdx == 0 ? null : [
                                    <MenuItem key={"2"} value={2}>Sum</MenuItem>,
                                    <MenuItem key={"3"} value={3}>Avg</MenuItem>,
                                    <MenuItem key={"4"} value={4}>Min</MenuItem>,
                                    <MenuItem key={"5"} value={5}>Max</MenuItem>,
                                    ]}
                            </Select>
                        </div>
                        )) : null}
                    <button onClick={addProjectionHandler} style={{...buttonStyle, ...{marginTop: "10px", marginLeft: "35px"}}}>
                        <AiFillPlusSquare size={33}/>
                    </button>
            </div>
            {doneButton(closeSideBarHandler)}
        </>;

    const conditionBuilder = <>
        {sideBarHeader("Condition Builder", closeSideBarHandler)}
        <div style={{marginTop: "10px", marginLeft: "10px"}}>
            <p>Column: {selectedHeaderName}</p>
            {selectedExpressions ? selectedExpressions.map((expressionData: IExpressionData, idx: number) => (
                selectedCoordinate?.colIdx != expressionData.colIdx ? null :
                <div key={idx} style={{margin: "10px"}}>
                    <button style={buttonStyle}>
                        <IoMdRemoveCircleOutline size={20} onClick={e => removeConditionHandler(idx)}/>
                    </button>
                    <FormControl>
                        <OutlinedInput id="outlined-adornment-amount" value={expressionData.expression.replace(startAdornment, "")} 
                            startAdornment={<div style={{color: "blue"}}>{startAdornment}</div>}
                            onChange={e => modifyExpressionHandler(e, idx)}
                            onKeyDown={e => {if(e.key == "Enter") closeConditionBuilderHandler()}}/>
                    </FormControl>
                </div>
                )) : null}
            <button onClick={addConditionHandler} style={{...buttonStyle, ...{marginTop: "10px", marginLeft: "35px"}}}>
                <AiFillPlusSquare size={33}/>
            </button>
        </div>
        {doneButton(closeConditionBuilderHandler)}
    </>;

    // Async updates
    useEffect(()=> {
        /* When selectedCoorinate changes.. */
        // 1. Show sidebar
        // TODO: check whether entire row is selected
        if (selectedCoordinate){
            setShowSideBar(true);
        }

        // 2. Refresh selectedExpressions
        // TODO: check whether entire row is selected
        if (selectedCoordinate) {
            // Get expressions from selectedCoordinate
            const existingExpressions: IExpressionData[] = selectedConditions ? selectedConditions.map((condition) => (
                {"colIdx": condition.header_id,
                "expression": conditionToExpression(condition, selectedEVQLNode.header_names)}
            )) : [];
            // Add default textfield if there are no expressions
            if (existingExpressions.filter((expression) => expression.colIdx == selectedCoordinate.colIdx).length == 0) {
                existingExpressions.push({"colIdx": selectedCoordinate.colIdx, "expression": ""});
            }
            setSelectedExpressions(existingExpressions);
        }
        // TODO: check whether entire row is selected
        // TODO: If so, ask whether to remove the entire row (via popup screen?)
        
    }, [selectedCoordinate]);

    // Return appropriate Element
    if (!showSideBar || isNothingSelected(selectedCoordinate)) return (<></>);
    else if (isHeaderSelected(selectedCoordinate)){
        return projectionBuilder;
    }
    else if(isCellSelected(selectedCoordinate)){
        return conditionBuilder;
    }
    else{
        console.warn(`unexpected coordinate: ${JSON.stringify(selectedCoordinate)}`);
        return (<></>);
    }
};

export default SideBar;