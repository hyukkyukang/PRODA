import { List, ListItemButton, ListItemIcon, ListItemText } from "@mui/material";
import { AssessmentOutlined, People, Settings } from "@mui/icons-material";

import { summaryMenuName, usersMenuName, settingsMenuName } from "../../pages/admin";

export const Sidebar = (props: any) => {
    const { selectedMenu, setSelectedMenu } = props;

    return (
        <>
            <h1 style={{ marginLeft: "25px" }}>PRODA</h1>
            <List sx={{ width: "100%", maxWidth: 360 }}>
                <ListItemButton onClick={(_) => setSelectedMenu(summaryMenuName)}>
                    <ListItemIcon>
                        <AssessmentOutlined style={{ color: "white" }} />
                    </ListItemIcon>
                    <ListItemText primary="Summary" />
                </ListItemButton>
                <ListItemButton onClick={(_) => setSelectedMenu(usersMenuName)}>
                    <ListItemIcon>
                        <People style={{ color: "white" }} />
                    </ListItemIcon>
                    <ListItemText primary="Users" />
                </ListItemButton>
                <ListItemButton onClick={(_) => setSelectedMenu(settingsMenuName)}>
                    <ListItemIcon>
                        <Settings style={{ color: "white" }} />
                    </ListItemIcon>
                    <ListItemText primary="Settings" />
                </ListItemButton>
            </List>
        </>
    );
};
