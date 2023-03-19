import React, { useState, useEffect } from "react";
import { Grid, Button } from "@mui/material";

import { isEmptyObject } from "../utils";
import { runEVQA, fetchEVQA, runSQL } from "../api/connect";
import { EVQATree } from "../components/VQA/EVQA";
import { EVQATables, Coordinate } from "../components/VQA/EVQATable";
import { TableExcerpt } from "../components/TableExcerpt/TableExcerpt";
import { SideBar } from "../components/VQA/Sidebar";

const HandsOnEVQA = (props: any) => {
    // Global variables (to children)
    const [selectedCoordinate, setSelectedCoordinate] = useState<Coordinate>();
    const [evqa, setEVQA] = useState({} as EVQATree);

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
        runSQL({ sql: `SELECT * FROM cars LIMIT 5` })
            .then((data) => {
                setSampledDBRows(data.rows);
            })
            .catch((e) => {
                console.warn(`error:${e}`);
            });
    };

    // Visualize EVQA
    const doInitSetting = async (queryName: string) => {
        // Fetch example EVQA
        const tmpEVQA = await fetchEVQA({ queryType: queryName });
        // Execute EVQA
        const tmpQueryResult = await runEVQA({ evqaStr: JSON.stringify(tmpEVQA) });
        // Set values
        setEVQA(tmpEVQA);
        setSQL(tmpQueryResult["sql"]);
        setQueryResult(tmpQueryResult["result"]);
    };

    const executeQuery: React.MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        runEVQA({ evqaStr: JSON.stringify(evqa) })
            .then((data) => {
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
        if (isEmptyObject(sampledDBRows)) {
            getRowsOfDemoDB();
        }
        if (exampleQueryName) doInitSetting(exampleQueryName);
    }, []);

    return (
        <Grid container style={{ background: "white", color: "black" }}>
            <Grid item xs={showSideBar ? 9 : 12}>
                <h1> Hands-On EVQA</h1>
                <div style={{ marginLeft: "10px" }}>
                    <div>
                        <h2> Demo Database </h2>
                        <p> Below is the "cars" table in our demo database: </p>
                        <TableExcerpt queryResult={sampledDBRows} />
                    </div>
                    <div>
                        <h2>EVQA Query</h2>
                        <p>Edit the EVQA table, and click "Run EVQA" to see the result. </p>
                        <EVQATables evqaRoot={evqa} setEVQARoot={setEVQA} setSelectedCoordinate={setSelectedCoordinate} />
                        <br />
                        <Button variant="contained" color="success" size="medium" onClick={executeQuery}>
                            {"Run EVQA"}{" "}
                        </Button>
                        <h3>Results:</h3>
                        <TableExcerpt queryResult={queryResult} />
                        <br />
                        {/* TODO: Remove debugging print below */}
                        SQL (for debug): {sql}
                        <br />
                        <br />
                    </div>
                </div>
            </Grid>
            <Grid item xs={3} style={{ background: "#f5f6f7", boxShadow: "-2px 0px 0px #e6e9ed" }}>
                <SideBar evqaRoot={evqa} setEVQA={setEVQA} selectedCoordinate={selectedCoordinate} showSideBar={showSideBar} setShowSideBar={setShowSideBar} />
            </Grid>
        </Grid>
    );
};

export default HandsOnEVQA;
