import config from "js-yaml-loader!../config.yml";

// Helper functions for objects
export function isString(obj) {
    return typeof obj === "string" || obj instanceof String;
}

export function isKeyValueObject(obj) {
    return !isNumber(obj) && !Array.isArray(obj) && !isString(obj);
}

export function isEmptyObject(obj) {
    // return obj == null || obj == undefined || (obj && !Array.isArray(obj) && Object.keys(obj).length === 0) || (obj && Array.isArray(obj) && obj.length === 0);
    return (
        obj == null || obj == undefined || (obj && isKeyValueObject(obj) && Object.keys(obj).length === 0) || (obj && Array.isArray(obj) && obj.length === 0)
    );
}

// Helper functions for string
export function removeMultipleSpaces(inputString) {
    return inputString.replace(/  +/g, " ");
}

export function isNumber(inputValue) {
    if (typeof inputValue == "number") return true;
    if (typeof inputValue != "string") return false; // we only process strings!
    return !isNaN(inputValue) && !isNaN(parseFloat(inputValue));
}

export function stripQutations(inputString) {
    return inputString.replace(/['"]+/g, "");
}

// Helper functions for array
export function isArrayEqual(arr1, arr2) {
    if (arr1.length != arr2.length) return false;
    for (var i = 0; i < arr1.length; i++) {
        if (arr1[i] != arr2[i]) return false;
    }
    return true;
}

/* After calling this function, new configs are appended to process.env */
export function getConfig() {
    return config.visibleToClient;
}

module.exports = {
    isEmptyObject: isEmptyObject,
    removeMultipleSpaces: removeMultipleSpaces,
    isNumber: isNumber,
    stripQutations: stripQutations,
    isArrayEqual: isArrayEqual,
    getConfig: getConfig,
};
