import axios from "axios";
import { ip, serverPort } from "../config";

const config = { headers: { "content-type": "application/json" } };

/* Fetch data */
export const fetchEVQL = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/fetchEVQL`, { params: params }, config)).data;
};

export const fetchTask = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/fetchTask`, { params: params }, config)).data;
};

export const fetchLogData = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/fetchLogData`, { params: params }, config)).data;
};

/* Send data*/
export const sendWorkerAnswer = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/logWorkerAnswer`, { params: params }, config)).data;
};

/* Send and request data */
export const runEVQL = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/runEVQL`, { params: params }, config)).data;
};

export const runSQL = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/runSQL`, { params: params }, config)).data;
};
