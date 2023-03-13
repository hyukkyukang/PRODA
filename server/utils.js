const fs = require("fs");
const yaml = require("js-yaml");

function loadYamlFile(path) {
    try {
        return yaml.load(fs.readFileSync(path, "utf8"));
    } catch (e) {
        console.log(e);
        return null;
    }
}

module.exports = {
    loadYamlFile: loadYamlFile,
};
