import MuiAlert, { AlertProps } from "@mui/material/Alert";
import Snackbar from "@mui/material/Snackbar";
import React from "react";

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(function Alert(props, ref) {
    return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
});

export const SubmitFailedSnackbar = ({
    isSubmitFailedSnackbarOpen,
    setIsSubmitFailedSnackbarOpen,
}: {
    isSubmitFailedSnackbarOpen: boolean;
    setIsSubmitFailedSnackbarOpen: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
    return (
        <Snackbar
            open={isSubmitFailedSnackbarOpen}
            autoHideDuration={6000}
            onClose={() => setIsSubmitFailedSnackbarOpen(false)}
            anchorOrigin={{ vertical: "bottom", horizontal: "center" }}
        >
            <Alert onClose={() => setIsSubmitFailedSnackbarOpen(false)} severity="error" sx={{ width: "100%" }}>
                Answer submission failed. Please provide an alternative sentence that differs from the provided sentence.
            </Alert>
        </Snackbar>
    );
};

export default SubmitFailedSnackbar;
