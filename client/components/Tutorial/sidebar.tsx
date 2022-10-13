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

    if (isEmptyObject(basicTutorialSections)) return <></>;
    return (
        <>
            <ListItem sx={{ fontWeight: "bold", fontSize: "20px", marginTop: 1 }}>Tutorial Sections</ListItem>
            <div style={{ fontWeight: "bold", fontSize: "20px" }}>
                <p> Basic </p>
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
                    {" "}
                    EVQL {value.title}{" "}
                </ListItem>
            ))}
            <div style={{ fontWeight: "bold", fontSize: "20px" }}>
                <p> Advance </p>
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
                    {" "}
                    EVQL {value.title}{" "}
                </ListItem>
            ))}
        </>
    );
};

export default SideBar;
