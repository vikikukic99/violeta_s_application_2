import { createServer } from "http";
import { setupAuth, isAuthenticated } from "./replitAuth.js";
import express from "express";
import cors from "cors";
export async function registerRoutes(app) {
    // Enable CORS for Flutter app
    app.use(cors({
        origin: true,
        credentials: true
    }));
    // Parse JSON bodies
    app.use(express.json());
    // Auth middleware
    await setupAuth(app);
    // Auth routes
    app.get('/api/auth/user', isAuthenticated, async (req, res) => {
        try {
            const user = req.user;
            res.json(user);
        }
        catch (error) {
            console.error("Error fetching user:", error);
            res.status(500).json({ message: "Failed to fetch user" });
        }
    });
    // Check auth status
    app.get('/api/auth/status', (req, res) => {
        res.json({
            isAuthenticated: req.isAuthenticated(),
            user: req.user || null
        });
    });
    // Protected route example
    app.get("/api/protected", isAuthenticated, async (req, res) => {
        const user = req.user;
        res.json({ message: "This is a protected route", user });
    });
    // Serve Flutter app static files
    app.use(express.static("build/web"));
    // Catch all handler for Flutter routes
    app.get("*", (req, res) => {
        res.sendFile("index.html", { root: "build/web" });
    });
    const httpServer = createServer(app);
    return httpServer;
}
