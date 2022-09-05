import { IPairData, dummyPairData } from "../PairData/PairData";

// TODO: Change to async and get info. from server
export const getPairDataOfUser = async (userName: string): Promise<IPairData[]> => {
    return dummyPairData.filter((pairData) => pairData.userName === userName);
};
