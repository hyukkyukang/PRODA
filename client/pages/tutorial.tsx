import { Button, Divider, Grid } from "@mui/material";
import { MouseEventHandler, useEffect, useState } from "react";
import { fetchEVQL, runEVQL, runSQL } from "../api/connect";
import { PGResultToTableExcerpt } from "../components/TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../components/TableExcerpt/TableExcerpt";
import { ITutorialSection } from "../components/Tutorial/sections/abstractSection";
import { allTutorialSections, ProjectionSection } from "../components/Tutorial/sections/allSections";
import { SideBar } from "../components/Tutorial/sidebar";
import { EVQLTree } from "../components/VQL/EVQL";
import { EVQLTables } from "../components/VQL/EVQLTable";
import { demoDBName } from "../config";
import { isEmptyObject } from "../utils";

const DividerWithMargin: JSX.Element = (
    <>
        <p />
        <Divider light={false} sx={{ marginTop: "2px", marginBottom: "2px" }} />
        <p />
    </>
);

const PageNavigationButtons = (prevButtonHandler: MouseEventHandler, nextButtonHandler: MouseEventHandler): JSX.Element => {
    return (
        <Grid container>
            <Grid item xs={0}>
                <Button variant="contained" color="success" size="medium" onClick={prevButtonHandler}>
                    {"< Previous"}
                </Button>
            </Grid>
            <Grid item xs={10}>
                <Button variant="contained" color="success" size="medium" sx={{ display: "float", float: "right" }} onClick={nextButtonHandler}>
                    {"Next >"}
                </Button>
            </Grid>
        </Grid>
    );
};

const Tutorial = () => {
    // Global variables
    const [selectedSection, setSelectedSection] = useState<ITutorialSection>(ProjectionSection);

    // Local variables
    const [evql, setEVQL] = useState({} as EVQLTree);
    const [sql, setSQL] = useState("");
    const [demoDBResult, setDemoDBResult] = useState<ITableExcerpt>({} as ITableExcerpt);
    const [queryResult, setQueryResult] = useState<ITableExcerpt>({} as ITableExcerpt);

    // Perform example settings
    const doExampleSettings = async (exampleQueryName: String) => {
        // Get sample EVQL
        const fetchedEVQL = await fetchEVQL({ queryType: exampleQueryName, dbName: demoDBName });
        // Execute EVQL
        const tmpQueryResult = await runEVQL({ evqlStr: JSON.stringify(fetchedEVQL), dbName: demoDBName });
        // Set values
        setEVQL(fetchedEVQL);
        setSQL(tmpQueryResult["sql"]);
        setQueryResult(PGResultToTableExcerpt(tmpQueryResult["result"]));
    };

    // get sampled DB Rows
    const getRowsOfDemoDB = async () => {
        // Handle data fetching
        runSQL({ sql: "SELECT * FROM cars", dbName: demoDBName })
            .then((result) => {
                setDemoDBResult(PGResultToTableExcerpt(result));
            })
            .catch((e) => {
                console.warn(`error:${e}`);
            });
    };

    const navigateToDemoPage: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        window.open(`handsOnEVQL?queryName=${selectedSection.exampleQueryName}`, "_blank", "noopener,noreferrer");
    };

    const selectPrevTutorialHandler: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        let index = allTutorialSections.indexOf(selectedSection);
        if (index != 0) {
            setSelectedSection(allTutorialSections[index - 1]);
        }
    };

    const selectNextTutorialHandler: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        let index = allTutorialSections.indexOf(selectedSection);
        if (index != allTutorialSections.length - 1) {
            setSelectedSection(allTutorialSections[index + 1]);
        }
    };

    // Once in the start
    useEffect(() => {
        if (isEmptyObject(demoDBResult)) {
            getRowsOfDemoDB();
        }
    }, []);

    // when the dependency changes
    useEffect(() => {
        if (selectedSection) {
            doExampleSettings(selectedSection.exampleQueryName);
        }
    }, [selectedSection]);

    return (
        <>
            <Grid container spacing={2} style={{ whiteSpace: "pre-wrap", lineHeight: "1.5" }}>
                <Grid item xs={2} sx={{ background: "#e6e9eb", color: "black", overflow: "auto" }}>
                    <SideBar selectedSection={selectedSection} setSelectedSection={setSelectedSection} />
                </Grid>
                <Grid item xs={10} sx={{ background: "white", color: "black" }}>
                    <h1>{selectedSection.title}</h1>
                    {PageNavigationButtons(selectPrevTutorialHandler, selectNextTutorialHandler)}
                    {DividerWithMargin}
                    <p>{selectedSection.description}</p>
                    {selectedSection.syntaxDescription}
                    <h2> Demo Database </h2>
                    <p> Below is a sampled rows from the "cars" table in our demo database: </p>
                    <TableExcerpt queryResult={demoDBResult} />
                    <h2> {selectedSection.title} Example</h2>
                    <p>{selectedSection.exampleDescription}</p>
                    <EVQLTables evqlRoot={evql} setEVQLRoot={setEVQL} editable={false} />
                    <p> Below is the query result from the Demo Database: </p>
                    {/* <p> SQL:{sql} </p> */}
                    <TableExcerpt queryResult={queryResult} />
                    <br />
                    <Button variant="contained" color="success" size="medium" onClick={navigateToDemoPage}>
                        {"Try it Yourself>>"}{" "}
                    </Button>
                    <br />
                    <br />
                    <Divider light={false} sx={{ marginTop: "2px", marginBottom: "2px" }} />
                    <br />
                    {PageNavigationButtons(selectPrevTutorialHandler, selectNextTutorialHandler)}
                    <br />
                </Grid>
            </Grid>
        </>
    );
};

export default Tutorial;
