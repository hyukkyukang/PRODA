import axios from "axios";

// Set configs
const protocol = process.env.HTTPS ? "https" : process.env.NEXT_PUBLIC_Protocol;
const ip = process.env.NEXT_PUBLIC_ServerIP;
const serverPort = process.env.NEXT_PUBLIC_ServerPort;
const config = { headers: { "content-type": "application/json" } };

console.log(`> Ready on ${protocol}://${ip}:${serverPort}`)

/* Fetch configs */
export const fetchConfig = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchConfig`, { params: params }, config)).data;
};

/* Fetch data */
export const fetchEVQL = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchEVQL`, { params: params }, config)).data;
};

export const fetchTask = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchTask`, { params: params }, config)).data;
};

export const fetchLogData = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/fetchLogData`, { params: params }, config)).data;
};

/* Send data*/
export const sendWorkerAnswer = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/logWorkerAnswer`, { params: params }, config)).data;
};

export const updateConfig = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/updateConfig`, { params: params }, config)).data;
};

/* Send and request data */
export const runEVQL = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/runEVQL`, { params: params }, config)).data;
};

export const runSQL = async (params) => {
    return (await axios.post(`${protocol}://${ip}:${serverPort}/runSQL`, { params: params }, config)).data;
};
