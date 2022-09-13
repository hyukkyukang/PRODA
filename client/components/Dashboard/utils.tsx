import { IUser } from "../User/User";
import { ILogData, isGreaterThan } from "../Dataset/PairData";

export const getUsersFromLogData = (logData: ILogData[]): IUser[] => {
    // TODO: add type to users variable
    const users: { [key: string]: IUser } = {};
    const dollarPerQuery = 10;
    logData.forEach((logDatum) => {
        const userName = logDatum.userName;
        if (Object.keys(users).includes(userName)) {
            users[userName]["profit"] += dollarPerQuery;
            users[userName]["collected"]++;
            users[userName]["lastActive"] = isGreaterThan(logDatum.date, users[userName]["lastActive"]) ? logDatum.date : users[userName]["lastActive"];
        } else {
            users[userName] = {
                name: userName,
                profit: dollarPerQuery,
                collected: 1,
                lastActive: logDatum.date,
            };
        }
    });
    return Object.values(users);
};
