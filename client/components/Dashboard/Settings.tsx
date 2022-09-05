import { useEffect, useState } from "react";
import { TextField, InputAdornment, Grid } from "@mui/material";
import { QueryType } from "../PairData/PairData";

const goalSettings = (querTypeName: string) => {
    const [goalNumOfQueries, setGoalNumOfQueries] = useState<number>(10);

    useEffect(() => {
        if (querTypeName) {
            setGoalNumOfQueries(10);
        }
    }, []);

    return (
        <>
            <Grid container spacing={2}>
                <Grid item xs={12} sm={4} sx={{ marginLeft: "25px" }}>
                    <span>{querTypeName}:</span>
                </Grid>
                <Grid item xs={12} sm={2}>
                    <TextField
                        label={"Number of queries to collect"}
                        defaultValue={goalNumOfQueries}
                        variant="filled"
                        onChange={(e) => setGoalNumOfQueries(parseFloat(e.target.value))}
                        fullWidth={true}
                    />
                </Grid>
            </Grid>
            <br />
        </>
    );
};

export const Settings = (props: any) => {
    const [totalBudget, setTotalBudget] = useState<number>(1000);
    const [pricePerDataPair, setPricePerDataPair] = useState<number>(0.5);

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
                            label="Total Budget"
                            defaultValue={totalBudget}
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
                            label="Price per data pair"
                            defaultValue={pricePerDataPair}
                            variant="filled"
                            InputProps={{
                                startAdornment: <InputAdornment position="start">$</InputAdornment>,
                            }}
                            onChange={(e) => setPricePerDataPair(parseFloat(e.target.value))}
                        />
                    </Grid>
                </Grid>
            </>
        );
    };

    const querySettings = () => {
        return (
            <>
                <h2>Query Setting</h2>
                {Object.values(QueryType).map((queryType) => goalSettings(queryType))}
            </>
        );
    };

    return (
        <>
            <h1>Settings</h1>
            <div style={{ marginLeft: "15px" }}>
                {budgetSettings()}
                <br />
                {querySettings()}
            </div>
            <br />
        </>
    );
};

export default Settings;
