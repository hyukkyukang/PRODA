var path = require("path");

function loadYamlFile(path) {
    const fs = require("fs");
    const yaml = require("js-yaml");
    try {
        return yaml.load(fs.readFileSync(path, "utf8"));
    } catch (e) {
        console.log(e);
        return null;
    }
}
const config = loadYamlFile("../config.yml");

// Read in arguments
const mode = process.argv[2];
console.log(`Running in ${mode} mode.`);
if (!["start", "dev"].includes(mode)) {
    console.error(`Invalid argument: ${mode}.\nPlease use either start or build.`);
    process.exit(1);
}

// Read in configs
const hostname = config.visibleToClient.frontend.IP;
const port = config.visibleToClient.frontend.Port;
const protocol = config.visibleToClient.frontend.Protocol;
const SSLKeyPath = path.join(config.ProjectPath, config.SSLKeyPath);
const SSLCertPath = path.join(config.ProjectPath, config.SSLCertPath);
const SSLCaPath = path.join(config.ProjectPath, config.SSLCaPath);
// Append configs to process.env

if (protocol == "http") {
    if (mode == "start") {
        const cli = require("next/dist/cli/next-start");
        cli.nextStart(["-p", port || 3000]);
    } else if (mode == "dev") {
        const cli = require("next/dist/cli/next-dev");
        cli.nextDev(["-p", port || 3000]);
    }
} else if (protocol == "https") {
    const { createServer } = require("https");
    const { parse } = require("url");
    const next = require("next");
    const fs = require("fs");

    const dev = process.env.NODE_ENV !== "production";

    // Create Server
    const httpsOptions = {
        key: fs.readFileSync(SSLKeyPath),
        cert: fs.readFileSync(SSLCertPath),
    };

    const app = next({ dev, hostname, port });
    const handle = app.getRequestHandler();
    app.prepare().then(() => {
        createServer(httpsOptions, async (req, res) => {
            try {
                const parsedUrl = parse(req.url, true);
                await handle(req, res, parsedUrl);
            } catch (err) {
                console.error("Error occurred handling", req.url, err);
                res.statusCode = 500;
                res.end("internal server error");
            }
        }).listen(port, (err) => {
            if (err) throw err;
            console.log(`> Ready on https://${hostname}:${port}`);
        });
    });
} else {
    console.error(`Invalid Protocol: ${config.Protocol}.\nPlease use either http or https.`);
}
