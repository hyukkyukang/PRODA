import React, { useState, MouseEventHandler } from "react";
import ListItem from "@mui/material/ListItem";

import { allTutorialSections, basicTutorialSections, advanceTutorialSections } from "./sections/allSections";
import { ITutorialSection } from "./sections/abstractSection";
import { isEmptyObject } from "../../utils";

interface ISelectedSection {
    selectedSection: ITutorialSection;
    setSelectedSection: React.Dispatch<React.SetStateAction<ITutorialSection>>;
}

export const SideBar = (params: ISelectedSection): React.ReactElement => {
    const [hoveringSection, setHoveringSection] = useState<ITutorialSection | null>(null);

    const sectionTitleToSectionClass = (title: string): ITutorialSection => {
        for (let i = 0; i < allTutorialSections.length; i++) {
            if (allTutorialSections[i].title === title) {
                return allTutorialSections[i];
            }
        }
        console.warn(`No section found for title:${title}. Returing first section.`);
        return allTutorialSections[0];
    };

    const handleClick: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        params.setSelectedSection(sectionTitleToSectionClass(e.currentTarget.id));
    };

    const handleMouseEnter: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        setHoveringSection(sectionTitleToSectionClass(e.currentTarget.id));
    };
    const handleMouseLeave: MouseEventHandler = (e: React.MouseEvent<HTMLDivElement, MouseEvent>): void => {
        setHoveringSection(null);
    };

    const getStyle = (section: ITutorialSection): React.CSSProperties => {
        if (section == params.selectedSection) {
            return { background: "green", color: "white" };
        } else if (section == hoveringSection) {
            return { background: "grey" };
        }
        return {};
    };

    const taskOverviewSection = (
        <React.Fragment>
            <ListItem
                sx={getStyle(null)}
                id={"Task Overview"}
                key={"Task Overview"}
                onClick={handleClick}
                onMouseEnter={handleMouseEnter}
                onMouseLeave={handleMouseLeave}
            >
                Task Overview
            </ListItem>
        </React.Fragment>
    );

    const basicSection = (
        <React.Fragment>
            <div style={{ paddingLeft: "10px", fontWeight: "bold", fontSize: "20px" }}>
                <p> EVQA Basic </p>
            </div>
            {basicTutorialSections.map((value) => (
                <ListItem
                    sx={getStyle(value)}
                    id={value.title}
                    key={value.title}
                    onClick={handleClick}
                    onMouseEnter={handleMouseEnter}
                    onMouseLeave={handleMouseLeave}
                >
                    {value.title}{" "}
                </ListItem>
            ))}
        </React.Fragment>
    );

    const advancedSection = (
        <React.Fragment>
            <div style={{ paddingLeft: "10px", fontWeight: "bold", fontSize: "20px" }}>
                <p> EVQA Advance </p>
            </div>
            {advanceTutorialSections.map((value) => (
                <ListItem
                    sx={getStyle(value)}
                    id={value.title}
                    key={value.title}
                    onClick={handleClick}
                    onMouseEnter={handleMouseEnter}
                    onMouseLeave={handleMouseLeave}
                >
                    {value.title}{" "}
                </ListItem>
            ))}
        </React.Fragment>
    );

    if (isEmptyObject(basicTutorialSections)) return <></>;
    return (
        <React.Fragment>
            <ListItem sx={{ fontWeight: "bold", fontSize: "20px", marginTop: 1 }}>Tutorial Sections</ListItem>
            {taskOverviewSection}
            {basicSection}
            {advancedSection}
        </React.Fragment>
    );
};

export default SideBar;
