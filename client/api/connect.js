import axios from "axios";
import { getConfig } from "../utils";
// Set configs
const config = getConfig();
const protocol = config.backend.Protocol;
const ip = config.backend.IP;
const serverPort = config.backend.Port;

const axioscConfig = { headers: { "content-type": "application/json" } };

/* Fetch configs */
export const fetchConfig = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchConfig`, { params: params }, axioscConfig)).data;
};

/* Fetch data */
export const fetchEVQL = async (params) => {
    const [key, queryType] = params.queryKey;
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchEVQL`, { queryType: queryType }, axioscConfig)).data;
};

export const fetchTask = async (params) => {
<<<<<<< HEAD
    const { workerId, taskID, isSkip } = params;
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchTask`, { workerId: workerId, taskID: taskID, isSkip: isSkip }, axioscConfig)).data;
=======
    const { workerID, taskSetID, isSkip } = params;
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchTask`, { workerID: workerID, taskSetID: taskSetID, isSkip: isSkip }, axioscConfig)).data;
>>>>>>> 3852206c33520deb109d3f8ae41a25238b1d87ba
};

export const fetchLogData = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchLogData`, { params: params }, axioscConfig)).data;
};

/* Send data*/
export const sendWorkerAnswer = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/logWorkerAnswer`, { params: params }, axioscConfig)).data;
};

export const updateConfig = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/updateConfig`, { params: params }, axioscConfig)).data;
};

/* Send and request data */
export const runEVQL = async (params) => {
    const [key, evql] = params.queryKey;
    return (await axios.post(`${protocol}://${ip}:${serverPort}/runEVQL`, { evql: evql }, axioscConfig)).data;
};

export const runSQL = async (params) => {
    const [key, sql] = params.queryKey;
    return (await axios.post(`${protocol}://${ip}:${serverPort}/runSQL`, { sql: sql }, axioscConfig)).data;
};
