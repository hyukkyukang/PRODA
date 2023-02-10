import { Box } from "@mui/material";
export const Header = () => {
    const style = {
        width: "100%",
        textAlign: "left",
        padding: "1px",
        backgroundColor: "#541554",
        color: "white",
        fontSize: "0.85em",
    };
    return (
        <Box sx={style}>
            <h1 style={{ marginLeft: "10px", color: "white" }}>Data Collection</h1>
        </Box>
    );
};
