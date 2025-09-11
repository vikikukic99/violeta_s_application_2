import { sql } from 'drizzle-orm';
import {
  boolean,
  index,
  integer,
  jsonb,
  numeric,
  pgTable,
  timestamp,
  varchar,
  unique,
} from "drizzle-orm/pg-core";

// Session storage table.
// (IMPORTANT) This table is mandatory for Replit Auth, don't drop it.
export const sessions = pgTable(
  "sessions",
  {
    sid: varchar("sid").primaryKey(),
    sess: jsonb("sess").notNull(),
    expire: timestamp("expire").notNull(),
  },
  (table) => ({
    expireIdx: index("IDX_session_expire").on(table.expire),
  }),
);

// User storage table.
// (IMPORTANT) This table is mandatory for Replit Auth, don't drop it.
export const users = pgTable("users", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  email: varchar("email").unique(),
  firstName: varchar("first_name"),
  lastName: varchar("last_name"),
  profileImageUrl: varchar("profile_image_url"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// Activity preferences table
export const activityPreferences = pgTable("activity_preferences", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  userId: varchar("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  activityType: varchar("activity_type").notNull(), // "Walking", "Running", "Cycling", etc.
  isSelected: boolean("is_selected").default(true),
  preferredTime: varchar("preferred_time"), // e.g., "10:00"
  description: varchar("description", { length: 500 }),
  location: varchar("location"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// Health profiles table - stores user health goals and settings
export const healthProfiles = pgTable("health_profiles", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  userId: varchar("user_id").notNull().references(() => users.id, { onDelete: "cascade" }).unique(),
  age: integer("age"),
  height: numeric("height", { precision: 5, scale: 2 }), // in cm
  weight: numeric("weight", { precision: 5, scale: 2 }), // in kg
  gender: varchar("gender", { length: 20 }), // "male", "female", "other"
  activityLevel: varchar("activity_level", { length: 50 }), // "sedentary", "lightly_active", "moderately_active", "very_active", "extremely_active"
  dailyStepsGoal: integer("daily_steps_goal").default(10000),
  dailyCaloriesGoal: integer("daily_calories_goal"),
  weeklyWorkoutsGoal: integer("weekly_workouts_goal").default(3),
  preferences: jsonb("preferences"), // Additional health preferences as JSON
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// Daily activities table - stores daily health metrics and activities
export const dailyActivities = pgTable(
  "daily_activities", 
  {
    id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: varchar("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
    date: timestamp("date").notNull(), // Date for the activity data
    steps: integer("steps").default(0),
    caloriesBurned: integer("calories_burned").default(0),
    distanceKm: numeric("distance_km", { precision: 8, scale: 3 }).default('0'), // in kilometers
    activeMinutes: integer("active_minutes").default(0),
    heartRateAvg: integer("heart_rate_avg"),
    heartRateMax: integer("heart_rate_max"),
    sleepHours: numeric("sleep_hours", { precision: 4, scale: 2 }),
    waterIntakeLiters: numeric("water_intake_liters", { precision: 4, scale: 2 }).default('0'),
    weight: numeric("weight", { precision: 5, scale: 2 }), // Daily weight tracking
    notes: varchar("notes", { length: 500 }),
    dataSource: varchar("data_source", { length: 100 }), // "manual", "google_fit", "apple_health", etc.
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
  },
  (table) => ({
    userDateUnique: unique("daily_activities_user_date_unique").on(table.userId, table.date),
  })
);

// Health integrations table - stores connected health service credentials and settings
export const healthIntegrations = pgTable(
  "health_integrations", 
  {
    id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: varchar("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
    serviceName: varchar("service_name").notNull(), // "google_fit", "apple_health", "fitbit", etc.
    isActive: boolean("is_active").default(true),
    accessToken: varchar("access_token", { length: 1000 }), // Encrypted access token
    refreshToken: varchar("refresh_token", { length: 1000 }), // Encrypted refresh token
    tokenExpiresAt: timestamp("token_expires_at"),
    settings: jsonb("settings"), // Service-specific settings
    lastSyncAt: timestamp("last_sync_at"),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
  },
  (table) => ({
    userServiceUnique: unique("health_integrations_user_service_unique").on(table.userId, table.serviceName),
  })
);

// Health sessions table - stores individual workout/activity sessions
export const healthSessions = pgTable("health_sessions", {
  id: varchar("id").primaryKey().default(sql`gen_random_uuid()`),
  userId: varchar("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  sessionType: varchar("session_type").notNull(), // "workout", "walk", "run", "cycle", "swim", etc.
  startTime: timestamp("start_time").notNull(),
  endTime: timestamp("end_time"),
  durationMinutes: integer("duration_minutes"),
  caloriesBurned: integer("calories_burned"),
  distanceKm: numeric("distance_km", { precision: 8, scale: 3 }),
  avgHeartRate: integer("avg_heart_rate"),
  maxHeartRate: integer("max_heart_rate"),
  steps: integer("steps"),
  location: varchar("location", { length: 200 }),
  notes: varchar("notes", { length: 500 }),
  dataSource: varchar("data_source", { length: 100 }).default("manual"),
  sessionData: jsonb("session_data"), // Additional session-specific data
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// Add indexes for better query performance
export const dailyActivitiesUserDateIdx = index("daily_activities_user_date_idx").on(dailyActivities.userId, dailyActivities.date);
export const healthSessionsUserIdx = index("health_sessions_user_idx").on(healthSessions.userId, healthSessions.startTime);
export const healthIntegrationsUserIdx = index("health_integrations_user_idx").on(healthIntegrations.userId, healthIntegrations.serviceName);

// Type exports
export type UpsertUser = typeof users.$inferInsert;
export type User = typeof users.$inferSelect;
export type ActivityPreference = typeof activityPreferences.$inferSelect;
export type UpsertActivityPreference = typeof activityPreferences.$inferInsert;

export type HealthProfile = typeof healthProfiles.$inferSelect;
export type UpsertHealthProfile = typeof healthProfiles.$inferInsert;
export type DailyActivity = typeof dailyActivities.$inferSelect;
export type UpsertDailyActivity = typeof dailyActivities.$inferInsert;
export type HealthIntegration = typeof healthIntegrations.$inferSelect;
export type UpsertHealthIntegration = typeof healthIntegrations.$inferInsert;
export type HealthSession = typeof healthSessions.$inferSelect;
export type UpsertHealthSession = typeof healthSessions.$inferInsert;