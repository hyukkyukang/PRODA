import React, { useState, useEffect } from "react";
import { IconButton, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from "@mui/material";
import { Box, Collapse, Typography, Paper } from "@mui/material";
import { KeyboardArrowDown, KeyboardArrowUp } from "@mui/icons-material";

import { ILogData, dateToString, dummyLogData } from "../Dataset/PairData";
import { IUser } from "../User/User";
import { getUsersFromLogData } from "./Summary/Summary";
import { fetchLogData } from "../../api/connect";

export const Users = (props: any) => {
    // Fetch user data
    const [users, setUsers] = useState<IUser[]>([]);
    const [logData, setLogData] = useState<ILogData[]>(dummyLogData);

    const getCollectedLogData = async () => {
        const fetchedData = await fetchLogData();
        const logData = fetchedData["logData"];
        // Get only desired data
        const selectedLogData: ILogData[] = [];
        for (let i = 0; i < logData.length; i++) {
            selectedLogData.push({
                userName: logData[i]["user_id"],
                dbName: logData[i]["given_dbName"],
                nl: logData[i]["given_nl"],
                sql: logData[i]["given_sql"],
                evql: logData[i]["given_evql"],
                queryType: logData[i]["queryType"],
                date: { year: 2022, month: 9, day: 12 },
            });
        }
        // Append with dummyLogData and save
        setLogData([...selectedLogData, ...dummyLogData]);
    };

    useEffect(() => {
        // Fetch log data from backend
        getCollectedLogData();
    }, []);

    useEffect(() => {
        if (logData) {
            const fetchedUsers = getUsersFromLogData(logData);
            setUsers(fetchedUsers);
        }
    }, [logData]);

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
                            {users.map((userDatum: any, idx: number) => (
                                <Row key={idx} userData={userDatum} logData={logData} />
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
    userData: IUser;
    logData: ILogData[];
}

const Row = (props: IRowContext) => {
    const { userData, logData } = props;
    const [isOpen, setIsOpen] = useState<boolean>(false);
    const [logDataOfSelectedUser, setLogDataOfSelectedUser] = useState<ILogData[]>([]);

    const toggleClickHandler: React.MouseEventHandler<HTMLButtonElement> = () => {
        setIsOpen(!isOpen);
    };

    useEffect(() => {
        if (userData?.name) {
            const filteredData = logData.filter((logData) => logData.userName === userData.name);
            console.log(`name: ${userData.name}, filteredData: ${JSON.stringify(filteredData)}`);
            setLogDataOfSelectedUser(filteredData);
        }
    }, [userData, logData]);

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
                                {logDataOfSelectedUser.map((logDatum: ILogData, idx: number) => (
                                    <TableRow key={idx}>
                                        <TableCell component="th" scope="row">
                                            {dateToString(logDatum.date)}
                                        </TableCell>
                                        <TableCell>{logDatum.nl}</TableCell>
                                        <TableCell align="left">{logDatum.sql}</TableCell>
                                        <TableCell align="left">{logDatum.queryType}</TableCell>
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
