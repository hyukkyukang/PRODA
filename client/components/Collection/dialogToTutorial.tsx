import CloseIcon from "@mui/icons-material/Close";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import IconButton from "@mui/material/IconButton";
import { styled } from "@mui/material/styles";
import Typography from "@mui/material/Typography";
import Link from "next/link";
import * as React from "react";

const BootstrapDialog = styled(Dialog)(({ theme }) => ({
    "& .MuiDialogContent-root": {
        padding: theme.spacing(2),
    },
    "& .MuiDialogActions-root": {
        padding: theme.spacing(1),
    },
}));

export interface DialogTitleProps {
    id: string;
    children?: React.ReactNode;
    onClose: () => void;
}

function BootstrapDialogTitle(props: DialogTitleProps) {
    const { children, onClose, ...other } = props;

    return (
        <DialogTitle sx={{ m: 0, p: 2 }} {...other}>
            {children}
            {onClose ? (
                <IconButton
                    aria-label="close"
                    onClick={onClose}
                    sx={{
                        position: "absolute",
                        right: 8,
                        top: 8,
                        color: (theme) => theme.palette.grey[500],
                    }}
                >
                    <CloseIcon />
                </IconButton>
            ) : null}
        </DialogTitle>
    );
}

export function DialogToTutorial({ isDialogOpen, setIsDialogOpen }: { isDialogOpen: boolean; setIsDialogOpen: React.Dispatch<React.SetStateAction<boolean>> }) {
    const handleClose = () => {
        setIsDialogOpen(false);
    };
    return (
        <React.Fragment>
            <BootstrapDialog onClose={handleClose} aria-labelledby="customized-dialog-title" open={isDialogOpen}>
                <BootstrapDialogTitle id="customized-dialog-title" onClose={handleClose}>
                    Before you begin
                </BootstrapDialogTitle>
                <DialogContent dividers>
                    <Typography gutterBottom>
                        To ensure the accurate execution of the task, kindly visit our{" "}
                        <Link href="/tutorial" target="_blank">
                            tutorial page
                        </Link>{" "}
                        and acquire a comprehensive understanding of both the task and the functionality of <i>EVQA</i>.
                    </Typography>
                    <Typography gutterBottom>Once you have gained a generally understanding of both, please return to this page and begin the task.</Typography>
                </DialogContent>
                <DialogActions>
                    <Button autoFocus onClick={handleClose}>
                        I have done reading the tutorial page
                    </Button>
                </DialogActions>
            </BootstrapDialog>
        </React.Fragment>
    );
}

export default DialogToTutorial;
