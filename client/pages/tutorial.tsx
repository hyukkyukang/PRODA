import { Button, Divider, Grid } from "@mui/material";
import React, { MouseEventHandler, useState, useMemo } from "react";
import { ITutorialSection } from "../components/Tutorial/sections/abstractSection";
import { allTutorialSections, TaskOverviewSection } from "../components/Tutorial/sections/allSections";
import { SideBar } from "../components/Tutorial/sidebar";

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
    const [selectedSection, setSelectedSection] = useState<ITutorialSection>(TaskOverviewSection);

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

    const EVQATutorial: JSX.Element = (
        <React.Fragment>
            <p>{selectedSection.description}</p>
            {selectedSection.syntaxDescription}
            <h2> Demo Table </h2>
            <p> Below is a sampled rows from the "cars" table in our demo table: </p>
            {selectedSection.exampleDescription}
        </React.Fragment>
    );

    const mainBody = useMemo((): JSX.Element => {
        if (selectedSection === undefined || selectedSection === null) {
            return <></>;
        } else if (selectedSection.itsOwnPage !== undefined) {
            return selectedSection.itsOwnPage;
        } else {
            return EVQATutorial;
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
                    {mainBody}
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
