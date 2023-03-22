import MuiAlert, { AlertProps } from "@mui/material/Alert";
import Snackbar from "@mui/material/Snackbar";
import React from "react";

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(function Alert(props, ref) {
    return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
});

export const SubmitSucceedSnackbar = ({
    isSubmitSucceedSnackbarOpen,
    setIsSubmitSucceedSnackbarOpen,
}: {
    isSubmitSucceedSnackbarOpen: boolean;
    setIsSubmitSucceedSnackbarOpen: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
    return (
        <Snackbar
            open={isSubmitSucceedSnackbarOpen}
            autoHideDuration={3000}
            onClose={() => setIsSubmitSucceedSnackbarOpen(false)}
            anchorOrigin={{ vertical: "bottom", horizontal: "center" }}
        >
            <Alert onClose={() => setIsSubmitSucceedSnackbarOpen(false)} severity="success" sx={{ width: "100%" }}>
                Answer submitted
            </Alert>
        </Snackbar>
    );
};

export default SubmitSucceedSnackbar;
