// Read in arguments
const mode = process.argv[2];
console.log(`Running in ${mode} mode.`);
if (!["start", "dev"].includes(mode)) {
    console.error(`Invalid argument: ${mode}.\nPlease use either start or build.`);
    process.exit(1);
}

// Read in configs
const { getConfig } = require("./utils");
const config = getConfig();

// Setup Server configs
const hostname = config.IP;
const port = config.port;
const dev = process.env.NODE_ENV !== "production";

if (config.Protocol == "http") {
    if (mode == "start") {
        const cli = require("next/dist/cli/next-start");
        cli.nextStart(["-p", port || 3000]);
    } else if (mode == "dev") {
        const cli = require("next/dist/cli/next-dev");
        cli.nextDev(["-p", port || 3000]);
    }
} else if (config.Protocol == "https") {
    const { createServer } = require("https");
    const { parse } = require("url");
    const next = require("next");
    const fs = require("fs");

    // Create Server
    const httpsOptions = {
        key: fs.readFileSync(config.SSLKeyPath),
        cert: fs.readFileSync(config.SSLCertPath),
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
