import React, { useState, useEffect } from "react";
import { Grid, Button } from "@mui/material";

import { demoDBName } from "../config";
import { isEmptyObject } from "../utils";
import { runEVQL, fetchEVQL, runSQL } from "../api/connect";
import { EVQLTree } from "../components/VQL/EVQL";
import { EVQLTables, Coordinate } from "../components/VQL/EVQLTable";
import { ResultTable } from "../components/ResultTable/resultTable";
import { SideBar } from "../components/VQL/Sidebar";

const HandsOnEVQL = (props: any) => {
    // Global variables (to children)
    const [selectedCoordinate, setSelectedCoordinate] = useState<Coordinate>();
    const [evql, setEVQL] = useState({} as EVQLTree);

    // Local variables
    const [sql, setSQL] = useState<string | undefined>("");
    const [queryResult, setQueryResult] = useState<any[] | undefined>();
    const [sampledDBRows, setSampledDBRows] = useState<any[]>([]);
    const [showSideBar, setShowSideBar] = useState<boolean>(false);

    // Get more global varibles
    let queryParams = typeof window === "undefined" ? null : new URLSearchParams(window.location.search);
    const exampleQueryName = queryParams && Boolean(queryParams) ? queryParams.get("queryName") : "";
    
    // get sampled DB Rows
    const getRowsOfDemoDB = async () => {
        // Handle data fetching
        runSQL({sql: `SELECT * FROM cars LIMIT 5`, dbName: demoDBName})
        .then(data => {
            setSampledDBRows(data['result']);
        })
        .catch((e) => {console.warn(`error:${e}`)});
    };

    // Visualize EVQL
    const doInitSetting = async (queryName: string) => {
        // Fetch example EVQL
        const tmpFetchResult = await fetchEVQL({queryType: queryName, dbName: demoDBName});
        const tmpEVQL = tmpFetchResult['evql'];
        // Execute EVQL
        const tmpQueryResult = await runEVQL({evqlStr: JSON.stringify(tmpEVQL), dbName: demoDBName});
        // Set values
        setEVQL(tmpEVQL);
        setSQL(tmpQueryResult['sql']);
        setQueryResult(tmpQueryResult['result']);
    };

    const executeQuery: React.MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        runEVQL({evqlStr: JSON.stringify(evql), dbName:demoDBName})
        .then(data => {
            setSQL(data["sql"]);
            setQueryResult(data["result"]);
        })
        .catch((e) => {
            console.warn(`error:${e}`);
            setSQL(undefined);
            setQueryResult(undefined);
        });
    };

    useEffect(() => {
        if (isEmptyObject(sampledDBRows)){
            getRowsOfDemoDB();
        }
        if (exampleQueryName) doInitSetting(exampleQueryName);
    }, []);

    return (
        <Grid container style={{background: "white", color:"black"}}>
            <Grid item xs={showSideBar ? 9 : 12}>
                <h1> Hands-On EVQL</h1>
                <div style={{marginLeft: "10px"}}>
                    <div>
                        <h2> Demo Database </h2>
                        <p> Below is the "cars" table in our demo database: </p>
                        <ResultTable queryResult={sampledDBRows}/>
                    </div>
                    <div>
                        <h2>EVQL Query</h2>
                        <p>Edit the EVQL table, and click "Run EVQL" to see the result. </p>
                        <EVQLTables evqlRoot={evql} setEVQLRoot={setEVQL} setSelectedCoordinate={setSelectedCoordinate}/>
                        <br/>
                        <Button variant="contained" color="success" size="medium" onClick={executeQuery}>{"Run EVQL"} </Button>
                        <h3>Results:</h3>
                        <ResultTable queryResult={queryResult}/>
                        <br/>
                        {/* TODO: Remove debugging print below */}
                        SQL (for debug): {sql}
                        <br/><br/>
                    </div>
                </div>
            </Grid>
            <Grid item xs={3} style={{background: "#f5f6f7", boxShadow: "-2px 0px 0px #e6e9ed"}}>
                <SideBar evqlRoot={evql} setEVQL={setEVQL} selectedCoordinate={selectedCoordinate} showSideBar={showSideBar} setShowSideBar={setShowSideBar}/>
            </Grid>
        </Grid>
    );
};

export default HandsOnEVQL;
