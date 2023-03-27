import classNames from "classnames";
import React from "react";
import { ColumnIndicatorComponent } from "react-spreadsheet-custom";
import { HoveringDescriptionContext, IEVQATableHeader } from "./EVQATable";
import { operatorDescriptions } from "./operatorDescriptions";
import { isEmptyObject } from "../../utils";
import { aggFunctions } from "./EVQA";
import { getHeaderDescription } from "./utils";

export const EVQAColumnIndicator: ColumnIndicatorComponent = ({ column, label, selected, selectedPoint, active, onSelect, activate }) => {
    const { setX, setY, setoperatorDescription, setIsActive } = React.useContext(HoveringDescriptionContext);
    const description = React.useMemo(() => (label ? getHeaderDescription(label as unknown as IEVQATableHeader) : ""), [label]);

    // column is the id
    const handleClick = React.useCallback(
        (event: React.MouseEvent) => {
            if (selectedPoint?.column == column && selectedPoint?.row == -1) {
                onSelect(-1);
            } else {
                onSelect(column);
            }
        },
        [onSelect, column, active, selected, selectedPoint]
    );
    const evqaTableHeader = label as unknown as IEVQATableHeader;

    // If isToProject,
    var unselectedHeaderStyle = {};
    var selectedHeaderStyle = {};
    var componentToDisplay: React.ReactElement = isEmptyObject(evqaTableHeader) ? <>{String(column)}</> : <>{evqaTableHeader.name}</>;
    if (!isEmptyObject(evqaTableHeader) && evqaTableHeader.isToProject) {
        // Highlight the header background
        unselectedHeaderStyle = { background: "#FFDDA7", color: "black" };
        // Get all aggregation functions applied to this column
        const aggFuncs = evqaTableHeader.aggFuncs.map((aggFuncId) => aggFunctions[aggFuncId]);
        componentToDisplay = (
            <>
                <>{evqaTableHeader.name}</>
                <br />
                {aggFuncs.join(", ") == "none" ? <></> : <div style={{ fontSize: "14px" }}>{"(" + aggFuncs.join(", ") + ")"}</div>}
            </>
        );
    }
    const handleMouseOver = React.useCallback((event: React.MouseEvent<HTMLTableCellElement>) => {
        if (activate) {
            activate({ row: -1, column: column });
        }
        // Set operator description
        if (setoperatorDescription) {
            setoperatorDescription(operatorDescriptions["="]);
            setoperatorDescription(description);
        }
        if (setIsActive) {
            setIsActive(true);
        }
    }, []);

    // Add mouse move listener
    React.useEffect(() => {
        const handleMouseMove = (event: any) => {
            if (setX && setY) {
                setX(event.clientX + window.pageXOffset);
                setY(event.clientY + window.pageYOffset);
            }
        };

        window.addEventListener("mousemove", handleMouseMove);

        return () => {
            window.removeEventListener("mousemove", handleMouseMove);
        };
    }, []);

    return (
        <th
            className={classNames("Spreadsheet__header", {
                "Spreadsheet__header--selected": active || selected,
            })}
            onClick={handleClick}
            onMouseEnter={handleMouseOver}
            tabIndex={0}
            style={active ? selectedHeaderStyle : unselectedHeaderStyle}
        >
            {componentToDisplay}
        </th>
    );
};
