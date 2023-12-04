import { createRequestHandler } from "@remix-run/express";
import { installGlobals } from "@remix-run/node";
import express from "express";

installGlobals();

let vite;
let ssrEntryPoint;
if(process.env.NODE_ENV !== "production"){
    const remixDev = await import ("@remix-run/dev");
    vite = await remixDev.unstable_createViteServer();
    ssrEntryPoint = remixDev.unstable_loadViteServerBuild(vite);
} else {
    vite = undefined;
    ssrEntryPoint = await import("./build/index.js");
}

const app = express();

// handle asset requests
if (vite) {
  app.use(vite.middlewares);
}

// handle SSR requests
app.all( "*", createRequestHandler({ build: ssrEntryPoint })
);

const port = 3000;
app.listen(port, () => console.log("http://localhost:" + port));
