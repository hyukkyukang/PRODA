import React, { useState, useEffect } from "react";
import { IconButton, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@mui/material";
import { Box, Collapse, Typography, Paper } from "@mui/material";
import { KeyboardArrowDown, KeyboardArrowUp } from "@mui/icons-material";

import { IPairData, dateToString } from "../PairData/PairData";
import { IUser } from "../User/User";
import { getPairDataOfUser } from "../User/utils";

interface IUserContext {
    userData: IUser[];
}

export const Users = (props: IUserContext) => {
    const { userData } = props;
    const [selectedUserName, setSelectedUserName] = useState<string>("");
    return (
        <>
            <h1>Worker Log</h1>
            <div style={{ marginRight: "15px", minHeight: "700px" }}>
                <br />
                <TableContainer component={Paper} sx={{ boxShadow: "0px 0px 5px grey" }}>
                    <Table aria-label="collapsible table">
                        <TableHead>
                            <TableRow>
                                <TableCell />
                                <TableCell sx={{ fontWeight: "bold" }}>Worker Name</TableCell>
                                <TableCell sx={{ fontWeight: "bold" }} align="right">
                                    Total Profit
                                </TableCell>
                                <TableCell sx={{ fontWeight: "bold" }} align="right">
                                    Collected Queries
                                </TableCell>
                                <TableCell sx={{ fontWeight: "bold" }} align="right">
                                    Last Active Date
                                </TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {userData.map((userDatum: any, idx: number) => (
                                <Row key={idx} data={userDatum} />
                            ))}
                        </TableBody>
                    </Table>
                </TableContainer>
                <br />
            </div>
        </>
    );
};

export default Users;

interface IRowContext {
    data: IUser;
}

const Row = (props: IRowContext) => {
    const { data } = props;
    const [isOpen, setIsOpen] = useState<boolean>(false);
    const [pairDataOfSelectedUser, setPairDataOfSelectedUser] = useState<IPairData[]>([]);

    const toggleClickHandler: React.MouseEventHandler<HTMLButtonElement> = () => {
        setIsOpen(!isOpen);
    };

    useEffect(() => {
        if (data?.name) {
            getPairDataOfUser(data.name).then((data) => {
                setPairDataOfSelectedUser(data);
            });
        }
    }, []);

    return (
        <React.Fragment>
            <TableRow sx={{ "& > *": { borderBottom: "unset" } }}>
                <TableCell>
                    <IconButton aria-label="expand row" size="small" onClick={toggleClickHandler}>
                        {isOpen ? <KeyboardArrowUp /> : <KeyboardArrowDown />}
                    </IconButton>
                </TableCell>
                <TableCell component="th" scope="row">
                    {data.name}
                </TableCell>
                <TableCell align="right">${data.profit}</TableCell>
                <TableCell align="right">{data.collected}</TableCell>
                <TableCell align="right">{dateToString(data.lastActive)}</TableCell>
            </TableRow>
            {/* Collapsed Info */}
            <TableCell style={{ paddingBottom: 0, paddingTop: 0 }} colSpan={6}>
                <Collapse in={isOpen} timeout="auto" unmountOnExit>
                    <Box sx={{ margin: 1 }}>
                        <Typography variant="h6" gutterBottom component="div">
                            Data Collected by {data.name}
                        </Typography>
                        <Table size="small" aria-label="purchases">
                            <TableHead>
                                <TableRow>
                                    <TableCell sx={{ fontWeight: "bold" }}>Date</TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }}>Natural Language</TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }} align="left">
                                        SQL
                                    </TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }} align="left">
                                        Query Type
                                    </TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {pairDataOfSelectedUser.map((pairDatum: IPairData, idx: number) => (
                                    <TableRow key={idx}>
                                        <TableCell component="th" scope="row">
                                            {dateToString(pairDatum.date)}
                                        </TableCell>
                                        <TableCell>{pairDatum.nl}</TableCell>
                                        <TableCell align="left">{pairDatum.sql}</TableCell>
                                        <TableCell align="left">{pairDatum.queryType}</TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </Box>
                </Collapse>
            </TableCell>
        </React.Fragment>
    );
};
