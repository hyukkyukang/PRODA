import classNames from "classnames";
import React from "react";
import { CellComponent, CellComponentProps, Dimensions, Point } from "react-spreadsheet-custom";

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

    const handleMouseDown = React.useCallback(
        (event: React.MouseEvent<HTMLTableCellElement>) => {
            if (selectedPoint?.column == column && selectedPoint?.row == row) {
                select({ row: -1, column: -1 });
            } else {
                select(point);
            }
        },
        [mode, setCellDimensions, point, select, active, selected, selectedPoint]
    );

    const handleMouseOver = React.useCallback(
        (event: React.MouseEvent<HTMLTableCellElement>) => {
            setCellDimensions(point, getOffsetRect(event.currentTarget));
            activate(point);
        },
        [setCellDimensions, select, dragging, point, active, selected, selectedPoint]
    );

    React.useEffect(() => {
        const root = rootRef.current;
        if (selected && root) {
            setCellDimensions(point, getOffsetRect(root));
        }
        if (root && active && mode === "view") {
            root.focus();
        }
    }, [setCellDimensions, selected, active, mode, point, data]);

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
