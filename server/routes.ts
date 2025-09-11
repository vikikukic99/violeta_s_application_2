import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage.js";
import { setupAuth, isAuthenticated } from "./replitAuth.js";
import { setupGoogleFitAuth, setupGoogleFitRoutes } from "./googleFitAuth.js";
import express from "express";
import cors from "cors";

export async function registerRoutes(app: Express): Promise<Server> {
  // Since we're serving the Flutter app from the same origin, we don't need permissive CORS
  // This improves security by preventing CSRF and data exfiltration attacks
  
  // Parse JSON bodies
  app.use(express.json());

  // Auth middleware
  await setupAuth(app);

  // Setup Google Fit authentication
  setupGoogleFitAuth();

  // Setup Google Fit routes
  setupGoogleFitRoutes(app);

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
    console.log('Auth status check:', {
      isAuthenticated: req.isAuthenticated(),
      hasUser: !!req.user,
      sessionID: req.sessionID,
      hasSession: !!req.session
    });
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

  // Health profile routes
  app.get('/api/health-profile', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const profile = await storage.getHealthProfile(user.id);
      
      if (!profile) {
        return res.status(404).json({ message: "Health profile not found" });
      }
      
      res.json(profile);
    } catch (error) {
      console.error("Error fetching health profile:", error);
      res.status(500).json({ message: "Failed to fetch health profile" });
    }
  });

  app.post('/api/health-profile', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const {
        age,
        height,
        weight,
        gender,
        activityLevel,
        dailyStepsGoal,
        dailyCaloriesGoal,
        weeklyWorkoutsGoal,
        preferences
      } = req.body;

      // Validate required fields
      if (age && (age < 1 || age > 150)) {
        return res.status(400).json({ message: "Age must be between 1 and 150" });
      }

      if (height && (height < 50 || height > 300)) {
        return res.status(400).json({ message: "Height must be between 50cm and 300cm" });
      }

      if (weight && (weight < 20 || weight > 500)) {
        return res.status(400).json({ message: "Weight must be between 20kg and 500kg" });
      }

      if (gender && !['male', 'female', 'other'].includes(gender.toLowerCase())) {
        return res.status(400).json({ message: "Gender must be 'male', 'female', or 'other'" });
      }

      if (activityLevel && !['sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active'].includes(activityLevel)) {
        return res.status(400).json({ message: "Invalid activity level" });
      }

      const profileData = {
        userId: user.id,
        age,
        height,
        weight,
        gender: gender?.toLowerCase(),
        activityLevel,
        dailyStepsGoal: dailyStepsGoal || 10000,
        dailyCaloriesGoal,
        weeklyWorkoutsGoal: weeklyWorkoutsGoal || 3,
        preferences,
      };

      const savedProfile = await storage.upsertHealthProfile(profileData);
      
      res.json({
        message: "Health profile saved successfully",
        profile: savedProfile
      });
    } catch (error) {
      console.error("Error saving health profile:", error);
      res.status(500).json({ message: "Failed to save health profile" });
    }
  });

  // Daily activities routes
  app.get('/api/daily-activities', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { date, startDate, endDate, limit } = req.query;

      let activities;

      if (date) {
        // Get activity for specific date
        const targetDate = new Date(date as string);
        const activity = await storage.getDailyActivity(user.id, targetDate);
        activities = activity ? [activity] : [];
      } else if (startDate && endDate) {
        // Get activities for date range
        const start = new Date(startDate as string);
        const end = new Date(endDate as string);
        activities = await storage.getDailyActivitiesRange(user.id, start, end);
      } else {
        // Get recent activities
        const limitNum = limit ? parseInt(limit as string) : 30;
        activities = await storage.getRecentDailyActivities(user.id, limitNum);
      }

      res.json(activities);
    } catch (error) {
      console.error("Error fetching daily activities:", error);
      res.status(500).json({ message: "Failed to fetch daily activities" });
    }
  });

  app.post('/api/daily-activities', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const {
        date,
        steps,
        caloriesBurned,
        distanceKm,
        activeMinutes,
        heartRateAvg,
        heartRateMax,
        sleepHours,
        waterIntakeLiters,
        weight,
        notes,
        dataSource
      } = req.body;

      // Validate required fields
      if (!date) {
        return res.status(400).json({ message: "Date is required" });
      }

      // Validate numeric fields
      if (steps && (steps < 0 || steps > 100000)) {
        return res.status(400).json({ message: "Steps must be between 0 and 100,000" });
      }

      if (caloriesBurned && (caloriesBurned < 0 || caloriesBurned > 10000)) {
        return res.status(400).json({ message: "Calories burned must be between 0 and 10,000" });
      }

      if (heartRateAvg && (heartRateAvg < 40 || heartRateAvg > 220)) {
        return res.status(400).json({ message: "Average heart rate must be between 40 and 220 BPM" });
      }

      if (heartRateMax && (heartRateMax < 40 || heartRateMax > 220)) {
        return res.status(400).json({ message: "Maximum heart rate must be between 40 and 220 BPM" });
      }

      if (sleepHours && (sleepHours < 0 || sleepHours > 24)) {
        return res.status(400).json({ message: "Sleep hours must be between 0 and 24" });
      }

      const activityData = {
        userId: user.id,
        date: new Date(date),
        steps: steps || 0,
        caloriesBurned: caloriesBurned || 0,
        distanceKm,
        activeMinutes: activeMinutes || 0,
        heartRateAvg,
        heartRateMax,
        sleepHours,
        waterIntakeLiters,
        weight,
        notes,
        dataSource: dataSource || 'manual',
      };

      const savedActivity = await storage.saveDailyActivity(activityData);
      
      res.json({
        message: "Daily activity saved successfully",
        activity: savedActivity
      });
    } catch (error) {
      console.error("Error saving daily activity:", error);
      res.status(500).json({ message: "Failed to save daily activity" });
    }
  });

  // Health integrations routes
  app.get('/api/health-integrations', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const integrations = await storage.getHealthIntegrations(user.id);
      
      // Remove sensitive data before sending to client
      const sanitizedIntegrations = integrations.map(integration => ({
        ...integration,
        accessToken: integration.accessToken ? '[PROTECTED]' : null,
        refreshToken: integration.refreshToken ? '[PROTECTED]' : null,
      }));
      
      res.json(sanitizedIntegrations);
    } catch (error) {
      console.error("Error fetching health integrations:", error);
      res.status(500).json({ message: "Failed to fetch health integrations" });
    }
  });

  app.post('/api/health-integrations', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const {
        serviceName,
        isActive,
        accessToken,
        refreshToken,
        tokenExpiresAt,
        settings
      } = req.body;

      // Validate required fields
      if (!serviceName) {
        return res.status(400).json({ message: "Service name is required" });
      }

      const validServices = ['google_fit', 'apple_health', 'fitbit', 'strava', 'garmin', 'samsung_health'];
      if (!validServices.includes(serviceName.toLowerCase())) {
        return res.status(400).json({ message: "Invalid service name" });
      }

      const integrationData = {
        userId: user.id,
        serviceName: serviceName.toLowerCase(),
        isActive: isActive !== false,
        accessToken,
        refreshToken,
        tokenExpiresAt: tokenExpiresAt ? new Date(tokenExpiresAt) : null,
        settings,
      };

      const savedIntegration = await storage.saveHealthIntegration(integrationData);
      
      // Remove sensitive data before sending response
      const sanitizedIntegration = {
        ...savedIntegration,
        accessToken: savedIntegration.accessToken ? '[PROTECTED]' : null,
        refreshToken: savedIntegration.refreshToken ? '[PROTECTED]' : null,
      };
      
      res.json({
        message: "Health integration saved successfully",
        integration: sanitizedIntegration
      });
    } catch (error) {
      console.error("Error saving health integration:", error);
      res.status(500).json({ message: "Failed to save health integration" });
    }
  });

  app.delete('/api/health-integrations/:serviceName', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { serviceName } = req.params;

      const deleted = await storage.deleteHealthIntegration(user.id, serviceName.toLowerCase());
      
      if (!deleted) {
        return res.status(404).json({ message: "Health integration not found" });
      }
      
      res.json({ message: "Health integration deleted successfully" });
    } catch (error) {
      console.error("Error deleting health integration:", error);
      res.status(500).json({ message: "Failed to delete health integration" });
    }
  });

  // Health sessions routes
  app.get('/api/health-sessions', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { startDate, endDate, limit } = req.query;

      let sessions;

      if (startDate && endDate) {
        // Get sessions for date range
        const start = new Date(startDate as string);
        const end = new Date(endDate as string);
        sessions = await storage.getHealthSessionsRange(user.id, start, end);
      } else {
        // Get recent sessions
        const limitNum = limit ? parseInt(limit as string) : 50;
        sessions = await storage.getHealthSessions(user.id, limitNum);
      }

      res.json(sessions);
    } catch (error) {
      console.error("Error fetching health sessions:", error);
      res.status(500).json({ message: "Failed to fetch health sessions" });
    }
  });

  app.post('/api/health-sessions', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const {
        sessionType,
        startTime,
        endTime,
        durationMinutes,
        caloriesBurned,
        distanceKm,
        avgHeartRate,
        maxHeartRate,
        steps,
        location,
        notes,
        dataSource,
        sessionData
      } = req.body;

      // Validate required fields
      if (!sessionType) {
        return res.status(400).json({ message: "Session type is required" });
      }

      if (!startTime) {
        return res.status(400).json({ message: "Start time is required" });
      }

      const validSessionTypes = ['workout', 'walk', 'run', 'cycle', 'swim', 'yoga', 'gym', 'dance', 'sports', 'hiking', 'other'];
      if (!validSessionTypes.includes(sessionType.toLowerCase())) {
        return res.status(400).json({ message: "Invalid session type" });
      }

      // Validate numeric fields
      if (durationMinutes && (durationMinutes < 0 || durationMinutes > 1440)) {
        return res.status(400).json({ message: "Duration must be between 0 and 1440 minutes" });
      }

      if (avgHeartRate && (avgHeartRate < 40 || avgHeartRate > 220)) {
        return res.status(400).json({ message: "Average heart rate must be between 40 and 220 BPM" });
      }

      if (maxHeartRate && (maxHeartRate < 40 || maxHeartRate > 220)) {
        return res.status(400).json({ message: "Maximum heart rate must be between 40 and 220 BPM" });
      }

      const sessionDataObj = {
        userId: user.id,
        sessionType: sessionType.toLowerCase(),
        startTime: new Date(startTime),
        endTime: endTime ? new Date(endTime) : null,
        durationMinutes,
        caloriesBurned,
        distanceKm,
        avgHeartRate,
        maxHeartRate,
        steps,
        location,
        notes,
        dataSource: dataSource || 'manual',
        sessionData,
      };

      const savedSession = await storage.saveHealthSession(sessionDataObj);
      
      res.json({
        message: "Health session saved successfully",
        session: savedSession
      });
    } catch (error) {
      console.error("Error saving health session:", error);
      res.status(500).json({ message: "Failed to save health session" });
    }
  });

  app.get('/api/health-sessions/:sessionId', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { sessionId } = req.params;

      const session = await storage.getHealthSession(sessionId);
      
      if (!session) {
        return res.status(404).json({ message: "Health session not found" });
      }
      
      // Ensure user can only access their own sessions
      if (session.userId !== user.id) {
        return res.status(403).json({ message: "Access denied" });
      }
      
      res.json(session);
    } catch (error) {
      console.error("Error fetching health session:", error);
      res.status(500).json({ message: "Failed to fetch health session" });
    }
  });

  app.delete('/api/health-sessions/:sessionId', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { sessionId } = req.params;

      const deleted = await storage.deleteHealthSession(sessionId, user.id);
      
      if (!deleted) {
        return res.status(404).json({ message: "Health session not found" });
      }
      
      res.json({ message: "Health session deleted successfully" });
    } catch (error) {
      console.error("Error deleting health session:", error);
      res.status(500).json({ message: "Failed to delete health session" });
    }
  });

  // Manual health data sync endpoint
  app.post('/api/sync-manual-data', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { syncData } = req.body;

      if (!syncData || !Array.isArray(syncData)) {
        return res.status(400).json({ message: "Sync data array is required" });
      }

      const results = [];
      
      for (const data of syncData) {
        const { type, ...dataFields } = data;
        
        try {
          if (type === 'daily_activity') {
            const activity = await storage.saveDailyActivity({
              userId: user.id,
              ...dataFields,
              dataSource: 'manual'
            });
            results.push({ type, status: 'success', data: activity });
          } else if (type === 'health_session') {
            const session = await storage.saveHealthSession({
              userId: user.id,
              ...dataFields,
              dataSource: 'manual'
            });
            results.push({ type, status: 'success', data: session });
          } else {
            results.push({ type, status: 'error', message: 'Invalid data type' });
          }
        } catch (error) {
          results.push({ type, status: 'error', message: error.message });
        }
      }

      res.json({
        message: "Manual sync completed",
        results
      });
    } catch (error) {
      console.error("Error syncing manual data:", error);
      res.status(500).json({ message: "Failed to sync manual data" });
    }
  });

  // Health stats summary endpoint
  app.get('/api/health-stats/summary', isAuthenticated, async (req: any, res) => {
    try {
      const user = req.user;
      const { period = '30' } = req.query;
      
      const days = parseInt(period as string);
      const endDate = new Date();
      const startDate = new Date();
      startDate.setDate(endDate.getDate() - days);

      const [profile, activities, sessions] = await Promise.all([
        storage.getHealthProfile(user.id),
        storage.getDailyActivitiesRange(user.id, startDate, endDate),
        storage.getHealthSessionsRange(user.id, startDate, endDate)
      ]);

      // Calculate summary statistics
      const totalSteps = activities.reduce((sum, activity) => sum + (activity.steps || 0), 0);
      const totalCalories = activities.reduce((sum, activity) => sum + (activity.caloriesBurned || 0), 0);
      const totalDistance = activities.reduce((sum, activity) => sum + parseFloat(activity.distanceKm || '0'), 0);
      const averageSleep = activities.length > 0 
        ? activities.reduce((sum, activity) => sum + parseFloat(activity.sleepHours || '0'), 0) / activities.length 
        : 0;

      const workoutCount = sessions.length;
      const averageWorkoutDuration = sessions.length > 0
        ? sessions.reduce((sum, session) => sum + (session.durationMinutes || 0), 0) / sessions.length
        : 0;

      res.json({
        period: `${days} days`,
        summary: {
          totalSteps,
          averageStepsPerDay: Math.round(totalSteps / days),
          totalCalories,
          averageCaloriesPerDay: Math.round(totalCalories / days),
          totalDistanceKm: Math.round(totalDistance * 100) / 100,
          averageDistancePerDay: Math.round((totalDistance / days) * 100) / 100,
          averageSleepHours: Math.round(averageSleep * 100) / 100,
          workoutCount,
          averageWorkoutDuration: Math.round(averageWorkoutDuration),
          goalsProgress: profile ? {
            stepsGoal: profile.dailyStepsGoal,
            stepsProgress: Math.min(100, Math.round((totalSteps / days / profile.dailyStepsGoal) * 100)),
            caloriesGoal: profile.dailyCaloriesGoal,
            caloriesProgress: profile.dailyCaloriesGoal ? Math.min(100, Math.round((totalCalories / days / profile.dailyCaloriesGoal) * 100)) : null,
            workoutsGoal: profile.weeklyWorkoutsGoal,
            workoutsProgress: Math.min(100, Math.round((workoutCount / (days / 7) / profile.weeklyWorkoutsGoal) * 100))
          } : null
        }
      });
    } catch (error) {
      console.error("Error fetching health stats summary:", error);
      res.status(500).json({ message: "Failed to fetch health stats summary" });
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