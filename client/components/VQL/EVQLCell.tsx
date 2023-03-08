import classNames from "classnames";
import React from "react";
import { CellComponent, CellComponentProps, Dimensions, Point } from "react-spreadsheet-custom";
import { HoveringDescriptionContext, TableHeaderContext } from "./EVQLTable";
import { parseExpressions, getCellDescription } from "./utils";

export function getOffsetRect(element: HTMLElement): Dimensions {
    return {
        width: element.offsetWidth,
        height: element.offsetHeight,
        left: element.offsetLeft,
        top: element.offsetTop,
    };
}

export const EVQLCell: CellComponent = ({
    row,
    column,
    DataViewer,
    formulaParser,
    selected,
    selectedPoint,
    active,
    dragging,
    mode,
    data,
    select,
    activate,
    setCellDimensions,
    setCellData,
}: CellComponentProps) => {
    const rootRef = React.useRef<HTMLTableCellElement | null>(null);
    const point = React.useMemo(
        (): Point => ({
            row,
            column,
        }),
        [row, column]
    );
    const { setX, setY, setDescription, setIsActive } = React.useContext(HoveringDescriptionContext);
    const { headerNames } = React.useContext(TableHeaderContext);
    const parsedExpressions = React.useMemo(
        () => (data?.value?.length > 0 ? parseExpressions(data?.value, headerNames) : null),
        [data, data?.value, headerNames]
    );
    const description: string = React.useMemo(() => (parsedExpressions ? getCellDescription(parsedExpressions) : ""), [parsedExpressions]);

    // Handle mouse down
    const handleMouseDown = React.useCallback(
        (event: any) => {
            if (selectedPoint?.column == column && selectedPoint?.row == row) {
                select({ row: -1, column: -1 });
            } else {
                select(point);
            }
        },
        [mode, setCellDimensions, point, select, active, selected, selectedPoint]
    );

    // Handle mouse over
    const handleMouseOver = React.useCallback(
        (event: React.MouseEvent<HTMLTableCellElement>) => {
            setCellDimensions(point, getOffsetRect(event.currentTarget));
            activate(point);
            // Set operator description
            setDescription(description);
            setIsActive(true);
        },
        [setCellDimensions, point, active, description]
    );

    // Default code from the library
    React.useEffect(() => {
        const root = rootRef.current;
        if (selected && root) {
            setCellDimensions(point, getOffsetRect(root));
        }
        if (root && active && mode === "view") {
            root.focus();
        }
    }, [setCellDimensions, selected, active, mode, point]);

    // Add mouse move listener
    React.useEffect(() => {
        const handleMouseMove = (event: any) => {
            setX(event.clientX + window.pageXOffset);
            setY(event.clientY + window.pageYOffset);
        };

        window.addEventListener("mousemove", handleMouseMove);

        return () => {
            window.removeEventListener("mousemove", handleMouseMove);
        };
    }, []);

    if (data && data.DataViewer) {
        // @ts-ignore
        DataViewer = data.DataViewer;
    }

    return (
        <td
            ref={rootRef}
            className={classNames("Spreadsheet__cell", data?.className, {
                "Spreadsheet__header--selected": active || selected,
            })}
            onMouseEnter={handleMouseOver}
            onMouseDown={handleMouseDown}
            tabIndex={0}
        >
            <DataViewer row={row} column={column} cell={data} formulaParser={formulaParser} setCellData={setCellData} />
        </td>
    );
};
