import express from "express";
import { registerRoutes } from "./routes.js";
import { db } from "./db.js";
import { sessions, users } from "../shared/schema.js";

// Load environment variables from .env file
import * as fs from "fs";
import * as path from "path";

// Simple .env loader
try {
  const envPath = path.resolve(process.cwd(), '.env');
  if (fs.existsSync(envPath)) {
    const envContent = fs.readFileSync(envPath, 'utf8');
    envContent.split('\n').forEach(line => {
      const [key, ...valueParts] = line.split('=');
      if (key && valueParts.length) {
        const value = valueParts.join('=').replace(/^["']|["']$/g, ''); // Remove quotes
        process.env[key] = value;
      }
    });
  }
} catch (error) {
  console.log('No .env file found, using system environment variables');
}

const app = express();
const port = Number(process.env.PORT) || 5000;

async function startServer() {
  try {
    console.log("Starting server...");
    
    // Verify database tables exist (basic health check)
    try {
      await db.select().from(sessions).limit(1);
      await db.select().from(users).limit(1);
      console.log("Database tables verified successfully");
    } catch (error) {
      console.log("Database tables may not exist. Run 'npm run db:push' to create them.");
      console.log("Continuing startup...");
    }
    
    const httpServer = await registerRoutes(app);
    
    httpServer.listen(port, "0.0.0.0", () => {
      console.log(`Server running on http://0.0.0.0:${port}`);
      console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
    });
    
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
}

startServer();