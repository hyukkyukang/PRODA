// Helper functions for objects
function isEmptyObject(obj) {
    return obj == null || obj == undefined || (obj && !Array.isArray(obj) && Object.keys(obj).length === 0) || (obj && Array.isArray(obj) && obj.length === 0);
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

module.exports = {
    isEmptyObject: isEmptyObject,
    removeMultipleSpaces: removeMultipleSpaces,
    isNumber: isNumber,
    stripQutations: stripQutations,
    isArrayEqual: isArrayEqual,
};
