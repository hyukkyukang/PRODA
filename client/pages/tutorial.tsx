import { Button, Divider, Grid } from "@mui/material";
import { MouseEventHandler, useEffect, useState, useMemo } from "react";
import { useQuery } from "react-query";
import { fetchEVQA, runEVQA, runSQL } from "../api/connect";
import { PGResultToTableExcerpt, PGResultInterface } from "../components/TableExcerpt/Postgres";
import { ITableExcerpt, TableExcerpt } from "../components/TableExcerpt/TableExcerpt";
import { ITutorialSection } from "../components/Tutorial/sections/abstractSection";
import { allTutorialSections, ProjectionSection } from "../components/Tutorial/sections/allSections";
import { SideBar } from "../components/Tutorial/sidebar";
import { EVQATree } from "../components/VQA/EVQA";
import { EVQATables } from "../components/VQA/EVQATable";

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

    // Use Query
    const demoDBTableQuery = useQuery<ITableExcerpt>(["runSQL", "SELECT * FROM cars"], runSQL);
    const fetchedEVQAQuery = useQuery<EVQATree>(["fetchEVQA", selectedSection.exampleQueryName], fetchEVQA, { cacheTime: 0 });
    const queryResultQuery = useQuery(["runEVQA", fetchedEVQAQuery?.data], runEVQA, { enabled: fetchedEVQAQuery?.data ? true : false });
    // Use Memo
    const demoDBResult = useMemo(
        () => (demoDBTableQuery?.data ? PGResultToTableExcerpt(demoDBTableQuery.data as unknown as PGResultInterface) : {}),
        [demoDBTableQuery.data]
    );
    const evqa = useMemo<EVQATree>(
        () => (fetchedEVQAQuery?.data ? fetchedEVQAQuery.data : ({} as EVQATree)),
        [selectedSection, fetchedEVQAQuery, fetchedEVQAQuery.data]
    );
    const queryResult = useMemo<ITableExcerpt>(
        () => (queryResultQuery?.data ? PGResultToTableExcerpt(queryResultQuery.data.result) : ({} as ITableExcerpt)),
        [queryResultQuery?.data]
    );

    const navigateToDemoPage: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        window.open(`handsOnEVQA?queryName=${selectedSection.exampleQueryName}`, "_blank", "noopener,noreferrer");
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
                    <EVQATables evqaRoot={evqa} editable={false} />
                    <p> Below is the query result from the Demo Database: </p>
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
