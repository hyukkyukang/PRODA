import { useState, useMemo, useEffect } from "react";
import { Grid, Card, CardContent, Typography } from "@mui/material";
import { LinearProgress, linearProgressClasses, styled } from "@mui/material";

import { ILogData, queryTypeNames, stringToDate } from "../../Dataset/PairData";
import { fetchLogData, fetchConfig } from "../../../api/connect";
import { IUser, UserTable } from "../../User/User";
import { getUsersFromLogData } from "../utils";
import { SummaryChart } from "./Chart";

const BorderLinearProgress = styled(LinearProgress)(({ theme }) => ({
    height: 6,
    borderRadius: 5,
    [`&.${linearProgressClasses.colorPrimary}`]: {
        backgroundColor: theme.palette.grey[theme.palette.mode === "light" ? 200 : 800],
    },
    [`& .${linearProgressClasses.bar}`]: {
        borderRadius: 5,
        backgroundColor: theme.palette.mode === "light" ? "green" : "#308fe8",
    },
}));

const calculateStatByQueryTypes = (logData: ILogData[]): { [key: string]: number } => {
    var countTypes: { [key: string]: number } = {};
    // Create a map of query types to count
    Object.values(queryTypeNames).forEach((value: string) => {
        countTypes[value] = 0;
    });
    // Count the number of each query type
    logData.forEach((logDatum) => {
        countTypes[logDatum.queryType]++;
    });
    return countTypes;
};

export const Summary = (props: any) => {
    const [remainingBlanace, setRemainingBlanace] = useState<number>(300);
    const [users, setUsers] = useState<IUser[]>([]);
    const [collectedLogData, setCollectedLogData] = useState<ILogData[]>([]);
    const dataStatByQueryType = useMemo(() => calculateStatByQueryTypes(collectedLogData), [collectedLogData]);
    const [goalNumOfQueries, setGoalNumOfQueries] = useState<{ [key: string]: number }>({});
    const totalGoalNumOfQueries: number = useMemo(
        () => (goalNumOfQueries ? Object.values(goalNumOfQueries).reduce((acc, value) => acc + value, 0) : 0),
        [goalNumOfQueries]
    );
    const [originalBalance, setOriginalBalance] = useState<number>(1000);

    const getCollectedLogData = async () => {
        const logData = await fetchLogData();
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
                user_nl: logData[i]["user_nl"],
                user_isCorrect: logData[i]["user_isCorrect"],
            });
        }
        setCollectedLogData([...selectedLogData]);
    };

    const getConfig = async () => {
        const fetchedData = await fetchConfig();
        // Set Balance
        setOriginalBalance(fetchedData["originalBalance"]);
        setRemainingBlanace(fetchedData["remainingBalance"]);
        // Set goalNumOfQueries
        const fetchedGoalNumOfQueries = fetchedData["goalNumOfQueries"] as { [key: string]: number };
        const newGoalNumOfQueries: { [key: string]: number } = {};
        Object.entries(fetchedGoalNumOfQueries).forEach(([key, value]) => {
            newGoalNumOfQueries[queryTypeNames[key]] = value;
        });
        setGoalNumOfQueries(newGoalNumOfQueries);
    };

    useEffect(() => {
        // Fetch log data from backend
        getCollectedLogData();
        // Fetch goal number of queries from backend
        getConfig();
    }, []);

    useEffect(() => {
        if (collectedLogData) {
            const fetchedUsers = getUsersFromLogData(collectedLogData);
            setUsers(fetchedUsers);
        }
    }, [collectedLogData]);

    return (
        <>
            <h1>Summary</h1>
            {/* Number of collected query */}
            <Grid container spacing={6}>
                {/* Number of crowdsource workers */}
                <Grid item xs={12} sm={4}>
                    <Card sx={{ minHeight: 170 }} style={{ boxShadow: "0px 0px 5px grey" }}>
                        <CardContent>
                            <Typography fontWeight={"bold"} fontFamily={"Roboto"} fontSize={20} align={"center"}>
                                Crowdsource Workers
                            </Typography>
                            <Typography fontWeight={"bold"} fontFamily={"Roboto"} fontSize={60} align={"center"}>
                                {users.length}
                            </Typography>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} sm={4}>
                    <Card sx={{ minHeight: 170 }} style={{ boxShadow: "0px 0px 5px grey" }}>
                        <CardContent>
                            <Typography fontWeight={"bold"} fontFamily={"Roboto"} fontSize={20} align={"center"}>
                                Collected Queries
                            </Typography>
                            <Typography fontWeight={"bold"} fontFamily={"Roboto"} fontSize={60} align={"center"}>
                                {collectedLogData.length}
                            </Typography>
                            <BorderLinearProgress variant="determinate" value={(collectedLogData.length * 100) / totalGoalNumOfQueries} />
                        </CardContent>
                    </Card>
                </Grid>
                {/* Number of remaining balance */}
                <Grid item xs={12} sm={4}>
                    <Card sx={{ minHeight: 170 }} style={{ boxShadow: "0px 0px 5px grey", marginRight: "20px" }}>
                        <CardContent>
                            <Typography fontWeight={"bold"} fontFamily={"Roboto"} fontSize={20} align={"center"}>
                                Remaining Balance
                            </Typography>
                            <Typography fontWeight={"bold"} fontFamily={"Roboto"} fontSize={60} align={"center"}>
                                ${remainingBlanace}
                            </Typography>
                            <BorderLinearProgress variant="determinate" value={(remainingBlanace * 100) / originalBalance} />
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
            {/* Summary by query types */}
            <br />
            <Card sx={{ minHeight: 170 }} style={{ boxShadow: "0px 0px 5px grey", marginRight: "20px" }}>
                <CardContent style={{ width: "100%", height: "500px" }}>{SummaryChart(dataStatByQueryType)}</CardContent>
            </Card>
            <br />
            {/* Summary of users */}
            <Grid container spacing={6}>
                <Grid item xs={12} sm={8}>
                    <Card style={{ boxShadow: "0px 0px 5px grey" }}>{UserTable(users)}</Card>
                </Grid>
                <Grid item xs={12} sm={4}>
                    <Card sx={{ boxShadow: "0px 0px 5px grey", marginRight: "20px" }}>
                        <CardContent>
                            <Typography fontSize={20} align={"left"} sx={{ marginLeft: "10px" }}>
                                Data Collection Progress <span style={{ fontSize: "18px" }}>(by types)</span>
                            </Typography>
                            <br />
                            {Object.entries(dataStatByQueryType).map((entry: [string, number], index: number) => (
                                <div key={index}>
                                    <Typography sx={{ marginTop: "5px" }}>
                                        {entry[0]} <span style={{ float: "right" }}>{(entry[1] * 100) / goalNumOfQueries[entry[0]]}%</span>
                                    </Typography>
                                    <BorderLinearProgress variant="determinate" value={(entry[1] * 100) / goalNumOfQueries[entry[0]]} />
                                </div>
                            ))}
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
            <br />
        </>
    );
};
export default Summary;
