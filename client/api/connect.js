import axios from "axios";
import { getConfig } from "../utils";
// Set configs
const config = getConfig();
const protocol = config.backend.Protocol;
const ip = config.backend.IP;
const serverPort = config.backend.Port;

/* Fetch configs */
export const fetchConfig = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchConfig`, { params: params }, axioscConfig)).data;
};

/* Fetch data */
export const fetchEVQL = async (params) => {
    const axioscConfig = { headers: { "content-type": "application/json" } };
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchEVQL`, { params: params }, axioscConfig)).data;
};

export const fetchTask = async (params) => {
    const [key, workerId] = params.queryKey;
    const axioscConfig = { headers: { "content-type": "application/json" } };
    console.log(`config: ${JSON.stringify(config)}`);
    console.log(`${protocol}://${ip}:${serverPort}/fetchTask`);
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchTask`, { workerId: workerId }, axioscConfig)).data;
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
    return (await axios.post(`${protocol}://${ip}:${serverPort}/runEVQL`, { params: params }, axioscConfig)).data;
};

export const runSQL = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/runSQL`, { params: params }, axioscConfig)).data;
};
