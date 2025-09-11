import express from "express";
import { registerRoutes } from "./routes.js";
const app = express();
const port = Number(process.env.PORT) || 5000;
async function startServer() {
    try {
        console.log("Starting server...");
        const httpServer = await registerRoutes(app);
        httpServer.listen(port, "0.0.0.0", () => {
            console.log(`Server running on http://0.0.0.0:${port}`);
        });
    }
    catch (error) {
        console.error("Failed to start server:", error);
        process.exit(1);
    }
}
startServer();
