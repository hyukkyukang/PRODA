import { Paper, TableContainer, Table, TableHead, TableBody, TableRow, TableCell } from "@mui/material";
import { IDate, dateToString } from "../PairData/PairData";

export interface IUser {
    name: string;
    profit: number;
    collected: number;
    lastActive: IDate;
}

export const dummyUsers: IUser[] = [
    { name: "John", profit: 100, collected: 2, lastActive: { year: 2022, month: 9, day: 1 } },
    { name: "Jane", profit: 200, collected: 2, lastActive: { year: 2022, month: 9, day: 2 } },
    { name: "Jack", profit: 300, collected: 1, lastActive: { year: 2022, month: 9, day: 3 } },
];

export const UserTable = (Users: IUser[]) => {
    return (
        <TableContainer component={Paper}>
            <Table size="medium">
                <TableHead>
                    <TableRow>
                        <TableCell sx={{ fontWeight: "bold" }} align="left">
                            Worker Name
                        </TableCell>
                        <TableCell sx={{ fontWeight: "bold" }} align="right">
                            Total Profit
                        </TableCell>
                        <TableCell sx={{ fontWeight: "bold" }} align="right">
                            Collected Queries
                        </TableCell>
                        <TableCell sx={{ fontWeight: "bold" }} align="right">
                            Last Active Date
                        </TableCell>
                    </TableRow>
                </TableHead>
                <TableBody>
                    {Users.map((user) => (
                        <TableRow key={user.name} sx={{ "&:last-child td, &:last-child th": { border: 0 } }}>
                            <TableCell component="th" scope="row">
                                {user.name}
                            </TableCell>
                            <TableCell align="right">${user.profit}</TableCell>
                            <TableCell align="right">{user.collected}</TableCell>
                            <TableCell align="right">{dateToString(user.lastActive)}</TableCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </TableContainer>
    );
};
