import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage.js";
import { setupAuth, isAuthenticated } from "./replitAuth.js";
import express from "express";
import cors from "cors";

export async function registerRoutes(app: Express): Promise<Server> {
  // Since we're serving the Flutter app from the same origin, we don't need permissive CORS
  // This improves security by preventing CSRF and data exfiltration attacks
  
  // Parse JSON bodies
  app.use(express.json());

  // Auth middleware
  await setupAuth(app);

  // Auth routes
  app.get('/api/auth/user', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      res.json(user);
    } catch (error) {
      console.error("Error fetching user:", error);
      res.status(500).json({ message: "Failed to fetch user" });
    }
  });

  // Check auth status
  app.get('/api/auth/status', (req: any, res) => {
    res.json({ 
      isAuthenticated: req.isAuthenticated(),
      user: req.user || null
    });
  });

  // Protected route example
  app.get("/api/protected", isAuthenticated, async (req: any, res) => {
    const user = req.user;
    res.json({ message: "This is a protected route", user });
  });

  // Activity preferences routes
  app.post('/api/activity-preferences', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { activities, location, preferredTime, description } = req.body;

      // Validate required fields
      if (!activities || !Array.isArray(activities)) {
        return res.status(400).json({ message: "Activities array is required" });
      }

      // Validate field lengths
      if (description && description.length > 500) {
        return res.status(400).json({ message: "Description must be 500 characters or less" });
      }

      if (location && location.length > 255) {
        return res.status(400).json({ message: "Location must be 255 characters or less" });
      }

      if (preferredTime && preferredTime.length > 255) {
        return res.status(400).json({ message: "Preferred time must be 255 characters or less" });
      }

      // Validate activity types
      const validActivityTypes = ['Walking', 'Running', 'Cycling', 'Swimming', 'Yoga', 'Gym', 'Dancing', 'Sports'];
      for (const activity of activities) {
        if (!activity.title && !activity.activityType) {
          return res.status(400).json({ message: "Each activity must have a title or activityType" });
        }
        
        const activityType = activity.title || activity.activityType;
        if (activityType && activityType.length > 255) {
          return res.status(400).json({ message: "Activity type must be 255 characters or less" });
        }
      }

      // Convert activities to database format - using proper boolean for isSelected
      const preferences = activities.map((activity: any) => ({
        userId: user.id,
        activityType: activity.title || activity.activityType,
        isSelected: Boolean(activity.isSelected),
        preferredTime: preferredTime,
        description: description,
        location: location,
      }));

      const savedPreferences = await storage.saveActivityPreferences(user.id, preferences);
      
      res.json({ 
        message: "Activity preferences saved successfully",
        preferences: savedPreferences 
      });
    } catch (error) {
      console.error("Error saving activity preferences:", error);
      res.status(500).json({ message: "Failed to save activity preferences" });
    }
  });

  app.get('/api/activity-preferences', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const preferences = await storage.getUserActivityPreferences(user.id);
      res.json(preferences);
    } catch (error) {
      console.error("Error fetching activity preferences:", error);
      res.status(500).json({ message: "Failed to fetch activity preferences" });
    }
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