import classNames from "classnames";
import React from "react";
import { ColumnIndicatorComponent } from "react-spreadsheet-custom";

import { isEmptyObject } from "../../utils";
import { aggFunctions } from "./EVQL";

export interface IEVQLTableHeader {
    name: string;
    aggFuncs: number[];
    isToProject: boolean;
}

export const EVQLColumnIndicator: ColumnIndicatorComponent = ({ column, label, selected, selectedPoint, active, onSelect, activate }) => {
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
    const evqlTableHeader = label as unknown as IEVQLTableHeader;

    // If isToProject,
    var unselectedHeaderStyle = {};
    var selectedHeaderStyle = {};
    var componentToDisplay: React.ReactElement = isEmptyObject(evqlTableHeader) ? <>{String(column)}</> : <>{evqlTableHeader.name}</>;
    if (!isEmptyObject(evqlTableHeader) && evqlTableHeader.isToProject) {
        // Highlight the header background
        unselectedHeaderStyle = { background: "#FFDDA7", color: "black" };
        // Get all aggregation functions applied to this column
        const aggFuncs = evqlTableHeader.aggFuncs.map((aggFuncId) => aggFunctions[aggFuncId]);
        componentToDisplay = (
            <>
                <>{evqlTableHeader.name}</>
                <br />
                {aggFuncs.join(", ") == "none" ? <></> : <div style={{ fontSize: "14px" }}>{"(" + aggFuncs.join(", ") + ")"}</div>}
            </>
        );
    }
    const handleMouseOver = React.useCallback((event: React.MouseEvent<HTMLTableCellElement>) => {
        activate({ row: -1, column: column });
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
