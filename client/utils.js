function isEmptyObject(obj){
    return obj == null || obj == undefined || 
    (obj && !Array.isArray(obj) && Object.keys(obj).length === 0) || 
    (obj && Array.isArray(obj) && obj.length === 0);
};

function removeMultipleSpaces(inputString){
    return inputString.replace(/  +/g, ' ');
};

function isNumber(inputString){
    if (typeof inputString != "string") return false // we only process strings!  
    return !isNaN(inputString) && !isNaN(parseFloat(inputString))
  };

module.exports = {
    isEmptyObject: isEmptyObject,
    removeMultipleSpaces: removeMultipleSpaces, 
    isNumber: isNumber
};
