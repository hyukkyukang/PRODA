import { Box } from "@mui/material";
import { useEffect, useState } from "react";

export const Footer = (props: { targetRef: any }) => {
    const { targetRef } = props;

    const style = {
        width: "100%",
        textAlign: "center",
        verticalAlign: "middle",
        padding: "10px",
        backgroundColor: "#272a35",
        color: "white",
        fontSize: "0.9em",
        justifyContent: "center",
    };
    const [dimensions, setDimensions] = useState({
        width: 100,
        height: 100,
    });

    const resizeHandler = () => {
        setDimensions({
            width: window.innerWidth,
            height: window.innerHeight,
        });
    };

    useEffect(() => {
        window.addEventListener("resize", resizeHandler, false);
    }, []);

    return (
        <Box sx={{ ...style, height: targetRef.current ? dimensions.height - targetRef.current.offsetHeight : "100%" }}>
            <p>&copy; POSTECH DSLab 2023</p>
        </Box>
    );
};

export default Footer;
