import { ILogData, dummyLogData } from "../Dataset/PairData";

// TODO: Change to async and get info. from server
export const getLogDataOfUser = async (userName: string): Promise<ILogData[]> => {
    return dummyLogData.filter((logData) => logData.userName === userName);
};
