const { createServer } = require("https");
const { parse } = require("url");
const next = require("next");
const fs = require("fs");

// Load environment variable
const dotenv = require('dotenv')
dotenv.config();

process.env.NEXT_PUBLIC_Protocol = "https";

// Setup Server configs
const hostname = process.env.NEXT_PUBLIC_ClientIP;
const port = process.env.NEXT_PUBLIC_WebPort;
const dev = process.env.NODE_ENV !== "production";
const httpsOptions = {
  key: fs.readFileSync(process.env.SSLKeyPath),
  cert: fs.readFileSync(process.env.SSLCertPath)
};

// Create Server
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
