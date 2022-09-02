import axios from "axios";
import { ip, serverPort } from "../config";

const config = {headers: {"content-type": "application/json"}};

export const fetchEVQL = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/fetchEVQL`, {params:params}, config)).data;
};

export const runEVQL = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/runEVQL`, {params:params}, config)).data;
};

export const runSQL = async (params) => {
    return (await axios.post(`http://${ip}:${serverPort}/runSQL`, {params:params}, config)).data;
};