// Helper functions for objects
const fs = require("fs");

// Load environment variable
const dotenv = require("dotenv");
dotenv.config();

// Load custom config
const yenv = require("yenv");
const config = yenv("../config.yml", { env: "frontend", strict: false });

function isString(obj) {
    return typeof obj === "string" || obj instanceof String;
}

function isKeyValueObject(obj) {
    return !isNumber(obj) && !Array.isArray(obj) && !isString(obj);
}

function isEmptyObject(obj) {
    // return obj == null || obj == undefined || (obj && !Array.isArray(obj) && Object.keys(obj).length === 0) || (obj && Array.isArray(obj) && obj.length === 0);
    return (
        obj == null || obj == undefined || (obj && isKeyValueObject(obj) && Object.keys(obj).length === 0) || (obj && Array.isArray(obj) && obj.length === 0)
    );
}

// Helper functions for string
function removeMultipleSpaces(inputString) {
    return inputString.replace(/  +/g, " ");
}

function isNumber(inputValue) {
    if (typeof inputValue == "number") return true;
    if (typeof inputValue != "string") return false; // we only process strings!
    return !isNaN(inputValue) && !isNaN(parseFloat(inputValue));
}

function stripQutations(inputString) {
    return inputString.replace(/['"]+/g, "");
}

// Helper functions for array
function isArrayEqual(arr1, arr2) {
    if (arr1.length != arr2.length) return false;
    for (var i = 0; i < arr1.length; i++) {
        if (arr1[i] != arr2[i]) return false;
    }
    return true;
}

function loadYamlFile(path) {
    try {
        return yaml.load(fs.readFileSync(path, "utf8"));
    } catch (e) {
        console.log(e);
        return null;
    }
}

/* After calling this function, new configs are appended to process.env */
function getConfig() {
    return config;
}

module.exports = {
    isEmptyObject: isEmptyObject,
    removeMultipleSpaces: removeMultipleSpaces,
    isNumber: isNumber,
    stripQutations: stripQutations,
    isArrayEqual: isArrayEqual,
    loadYamlFile: loadYamlFile,
    getConfig: getConfig,
};
