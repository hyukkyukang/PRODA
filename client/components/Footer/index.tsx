import { Box } from "@mui/material";
import { borderTop } from "@mui/system";
export const Footer = () => {
    const style = {
        width: "100%",
        textAlign: "center",
        padding: "1px",
        backgroundColor: "#272a35",
        color: "white",
        fontSize: "0.85em",
    };

    return (
        <>
            <Box sx={style}>
                <p>&copy; POSTECH DSLab 2023</p>
            </Box>
        </>
    );
};

export default Footer;
