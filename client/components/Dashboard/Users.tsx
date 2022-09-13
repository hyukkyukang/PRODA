import React, { useState, useEffect, useMemo } from "react";
import { IconButton, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@mui/material";
import { Box, Collapse, Typography, Paper } from "@mui/material";
import { KeyboardArrowDown, KeyboardArrowUp } from "@mui/icons-material";

import { ILogData, dateToString, stringToDate } from "../Dataset/PairData";
import { fetchLogData } from "../../api/connect";
import { getUsersFromLogData } from "./utils";
import { IUser } from "../User/User";

const Row = (props: { userData: IUser; logData: ILogData[] }) => {
    const { userData, logData } = props;
    const [isOpen, setIsOpen] = useState<boolean>(false);
    const logDataOfSelectedUser = useMemo(() => logData.filter((logDatum) => logDatum.userName === userData.name), [logData, userData.name]);

    const toggleClickHandler: React.MouseEventHandler<HTMLButtonElement> = () => {
        setIsOpen(!isOpen);
    };

    const toDashIfNullOrEmpty = (value: any | null) => {
        return value === null || value === "" ? "-" : value;
    };

    return (
        <React.Fragment>
            <TableRow sx={{ "& > *": { borderBottom: "unset" } }}>
                <TableCell>
                    <IconButton aria-label="expand row" size="small" onClick={toggleClickHandler}>
                        {isOpen ? <KeyboardArrowUp /> : <KeyboardArrowDown />}
                    </IconButton>
                </TableCell>
                <TableCell component="th" scope="row">
                    {userData.name}
                </TableCell>
                <TableCell align="right">${userData.profit}</TableCell>
                <TableCell align="right">{userData.collected}</TableCell>
                <TableCell align="right">{dateToString(userData.lastActive)}</TableCell>
            </TableRow>
            {/* Collapsed Info */}
            <TableCell style={{ paddingBottom: 0, paddingTop: 0 }} colSpan={6}>
                <Collapse in={isOpen} timeout="auto" unmountOnExit>
                    <Box sx={{ margin: 1 }}>
                        <Typography variant="h6" gutterBottom component="div">
                            Data Collected by {userData.name}
                        </Typography>
                        <Table size="small" aria-label="purchases">
                            <TableHead>
                                <TableRow>
                                    <TableCell sx={{ fontWeight: "bold" }}>Date</TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }} align="left">
                                        Query Type
                                    </TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }} align="left">
                                        SQL
                                    </TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }}>System's Natural Language</TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }}>User's Natural Language</TableCell>
                                    <TableCell sx={{ fontWeight: "bold" }}>User's correctness mark</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {logDataOfSelectedUser.map((logDatum: ILogData, idx: number) => (
                                    <TableRow key={idx}>
                                        <TableCell component="th" scope="row">
                                            {dateToString(logDatum.date)}
                                        </TableCell>
                                        <TableCell align="left">{toDashIfNullOrEmpty(logDatum.queryType)}</TableCell>
                                        <TableCell align="left">{toDashIfNullOrEmpty(logDatum.sql)}</TableCell>
                                        <TableCell>{logDatum.nl}</TableCell>
                                        <TableCell align="left">{toDashIfNullOrEmpty(logDatum.user_nl)}</TableCell>
                                        <TableCell align="left">{String(toDashIfNullOrEmpty(logDatum.user_isCorrect))}</TableCell>
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

export const Users = (props: {}) => {
    const [logData, setLogData] = useState<ILogData[]>();
    const users = useMemo(() => (logData ? getUsersFromLogData(logData) : null), [logData]);

    const getCollectedLogData = async () => {
        const logData = await fetchLogData();
        // Get only desired data
        const selectedLogData: ILogData[] = [];
        for (let i = 0; i < logData.length; i++) {
            selectedLogData.push({
                userName: logData[i]["user_id"],
                dbName: logData[i]["given_dbName"],
                nl: logData[i]["given_nl"],
                sql: logData[i]["given_sql"],
                evql: logData[i]["given_evql"],
                queryType: logData[i]["given_queryType"],
                date: stringToDate(logData[i]["date"]),
                user_isCorrect: logData[i]["user_isCorrect"],
                user_nl: logData[i]["user_nl"],
            });
        }
        setLogData([...selectedLogData]);
    };

    useEffect(() => {
        // Fetch log data from backend
        getCollectedLogData();
    }, []);

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
                            {users?.map((userDatum: any, idx: number) => (
                                <Row key={idx} userData={userDatum} logData={logData ?? []} />
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
