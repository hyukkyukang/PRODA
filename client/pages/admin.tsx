import { useState } from "react";
import { Grid } from "@mui/material";

import { Sidebar } from "../components/Dashboard/Sidebar";
import { Summary } from "../components/Dashboard/Summary/Summary";
import { Users } from "../components/Dashboard/Users";
import { Settings } from "../components/Dashboard/Settings";

export const summaryMenuName = "Summary";
export const usersMenuName = "Users";
export const settingsMenuName = "Settings";

export const Admin = (props: any) => {
    const [selectedMenu, setSelectedMenu] = useState(summaryMenuName);

    const getComponentOfSelectedMenu = (): React.ReactElement => {
        if (selectedMenu === summaryMenuName) {
            return <Summary />;
        } else if (selectedMenu === usersMenuName) {
            return <Users />;
        } else if (selectedMenu === settingsMenuName) {
            return <Settings />;
        } else {
            console.error("Unknown menu selected");
            return <></>;
        }
    };

    return (
        <div>
            <Grid container spacing={2} style={{ whiteSpace: "pre-wrap", lineHeight: "1.5" }}>
                <Grid item xs={2} sx={{ background: "#262b3f", color: "white", overflow: "auto" }}>
                    <Sidebar selectedMenu={selectedMenu} setSelectedMenu={setSelectedMenu} />
                </Grid>
                <Grid item xs={10} sx={{ background: "#f3f6fa", color: "black" }}>
                    {getComponentOfSelectedMenu()}
                </Grid>
            </Grid>
        </div>
    );
};

export default Admin;
