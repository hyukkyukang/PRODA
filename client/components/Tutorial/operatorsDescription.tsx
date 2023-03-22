import React from "react";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";
import { operatorDescriptions } from "../VQA/operatorDescriptions";

// Read in json file

function createData(name: string, description: string) {
    return { name, description };
}

const rows = Object.entries(operatorDescriptions).map(([name, description]) => createData(name, description));

export const OperatorsDescription: JSX.Element = (
    <React.Fragment>
        <TableContainer component={Paper}>
            <Table sx={{ minWidth: 650 }} size="small" aria-label="a dense table">
                <TableHead>
                    <TableRow>
                        <TableCell sx={{ fontWeight: "bold" }}>Name</TableCell>
                        <TableCell sx={{ fontWeight: "bold" }} align="left">
                            Desciption
                        </TableCell>
                    </TableRow>
                </TableHead>
                <TableBody>
                    {rows.map((row) => (
                        <TableRow key={row.name} sx={{ "&:last-child td, &:last-child th": { border: 0 } }}>
                            <TableCell component="th" scope="row" sx={{ fontWeight: "bold" }}>
                                {row.name}
                            </TableCell>
                            <TableCell align="left">{row.description}</TableCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </TableContainer>
    </React.Fragment>
);

export default OperatorsDescription;
