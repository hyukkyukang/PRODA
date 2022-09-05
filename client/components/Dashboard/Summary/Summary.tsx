import { useState, useMemo } from "react";
import { Grid, Card, CardContent, Typography } from "@mui/material";
import { LinearProgress, linearProgressClasses, styled } from "@mui/material";

import { IUser, UserTable, dummyUsers } from "../../User/User";
import { SummaryChart } from "./Chart";
import { IPairData, dummyPairData, QueryType, dummyGoalNumOfQueries } from "../../PairData/PairData";

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

const calculateStatByQueryTypes = (pairData: IPairData[]) => {
    var countTypes: { [key: string]: number } = {};
    // Create a map of query types to count
    Object.values(QueryType).forEach((value: string) => {
        countTypes[value] = 0;
    });
    // Count the number of each query type
    pairData.forEach((pairDatum) => {
        countTypes[pairDatum.queryType]++;
    });
    return countTypes;
};

export const Summary = (props: any) => {
    const [remainingBlanace, setRemainingBlanace] = useState<number>(300);
    const [users, setUsers] = useState<IUser[]>(dummyUsers);
    const [collectedPairData, setCollectedPairData] = useState<IPairData[]>(dummyPairData);
    const dataStatByQueryType = useMemo(() => calculateStatByQueryTypes(collectedPairData), [collectedPairData]);
    const totalGoalNumOfQueries = Object.values(dummyGoalNumOfQueries).reduce((acc, value) => acc + value, 0);

    // TODO: Retrieve original balance from backend
    const OriginalBalance = 1000;

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
                                {collectedPairData.length}
                            </Typography>
                            <BorderLinearProgress variant="determinate" value={(collectedPairData.length * 100) / totalGoalNumOfQueries} />
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
                            <BorderLinearProgress variant="determinate" value={(remainingBlanace * 100) / OriginalBalance} />
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
                            {Object.keys(dataStatByQueryType).map((queryType, index) => (
                                <div key={index}>
                                    <Typography sx={{ marginTop: "5px" }}>
                                        {queryType}{" "}
                                        <span style={{ float: "right" }}>{(dataStatByQueryType[queryType] * 100) / dummyGoalNumOfQueries[queryType]}%</span>
                                    </Typography>
                                    <BorderLinearProgress
                                        variant="determinate"
                                        value={(dataStatByQueryType[queryType] * 100) / dummyGoalNumOfQueries[queryType]}
                                    />
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
