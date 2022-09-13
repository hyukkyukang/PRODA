import { useEffect, useState } from "react";
import { Button, TextField, InputAdornment, Grid } from "@mui/material";

import { fetchConfig, updateConfig } from "../../api/connect";
import { queryTypeNames } from "../Dataset/PairData";

export const Settings = (props: {}) => {
    const [totalBudget, setTotalBudget] = useState<number>();
    const [pricePerDataPair, setPricePerDataPair] = useState<number>();
    const [goalNumOfQueries, setGoalNumOfQueries] = useState<{ [key: string]: number }>({});

    const getConfig = async () => {
        const fetchedConfig = await fetchConfig();
        setTotalBudget(fetchedConfig["originalBalance"]);
        setPricePerDataPair(fetchedConfig["pricePerDataPair"]);
        setGoalNumOfQueries(fetchedConfig["goalNumOfQueries"]);
    };

    const configUpdateHandler = async () => {
        const result: { [key: string]: string } = await updateConfig({
            totalBudget: totalBudget,
            pricePerDataPair: pricePerDataPair,
            goalNumOfQueries: goalNumOfQueries,
        });
        const status = result["status"];
        if (status == "success") alert("Config updated!");
        else alert("Server error! Update not successful.");
    };

    const budgetSettings = (): JSX.Element => {
        return (
            <>
                <h2>Budget Setting</h2>
                <Grid container spacing={2}>
                    <Grid item xs={12} sm={2} sx={{ marginLeft: "25px" }}>
                        <span>Total Budget:</span>
                    </Grid>
                    <Grid item xs={12} sm={2}>
                        <TextField
                            type="number"
                            label="Total Budget"
                            value={totalBudget}
                            variant="filled"
                            InputProps={{
                                startAdornment: <InputAdornment position="start">$</InputAdornment>,
                            }}
                            onChange={(e) => setTotalBudget(Number(e.target.value))}
                        />
                    </Grid>
                </Grid>
                <br />
                <Grid container spacing={2}>
                    <Grid item xs={12} sm={2} sx={{ marginLeft: "25px" }}>
                        <span>Price per data pair:</span>
                    </Grid>
                    <Grid item xs={12} sm={2}>
                        <TextField
                            type="number"
                            label="Price per data pair"
                            value={pricePerDataPair}
                            variant="filled"
                            InputProps={{
                                startAdornment: <InputAdornment position="start">$</InputAdornment>,
                            }}
                            onChange={(e) => setPricePerDataPair(Number(e.target.value))}
                        />
                    </Grid>
                </Grid>
            </>
        );
    };

    const querySettings = (): JSX.Element => {
        return (
            <>
                <h2>Query Setting</h2>
                {Object.entries(goalNumOfQueries).map((entry: [string, number]) => goalSettings(entry[0], entry[1]))}
            </>
        );
    };

    const goalSettings = (queryType: string, goalNum: number): JSX.Element => {
        const newGoalNumHandler = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
            const newGoal: number = Number(e.target.value);
            setGoalNumOfQueries({ ...goalNumOfQueries, [queryType]: newGoal });
        };
        return (
            <>
                <Grid container spacing={2}>
                    <Grid item xs={12} sm={4} sx={{ marginLeft: "25px" }}>
                        <span>{queryTypeNames[queryType]}:</span>
                    </Grid>
                    <Grid item xs={12} sm={2}>
                        <TextField
                            type="number"
                            label={"Number of queries to collect"}
                            defaultValue={goalNum}
                            variant="filled"
                            onChange={newGoalNumHandler}
                            fullWidth={true}
                        />
                    </Grid>
                </Grid>
                <br />
            </>
        );
    };

    useEffect(() => {
        getConfig();
    }, []);

    return (
        <>
            <h1>Settings</h1>
            <div style={{ marginLeft: "15px" }}>
                {budgetSettings()}
                <br />
                {querySettings()}
                <Button variant="contained" color="success" onClick={configUpdateHandler}>
                    Update
                </Button>
            </div>
            <br />
        </>
    );
};

export default Settings;
