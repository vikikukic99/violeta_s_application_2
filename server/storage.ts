import {
  users,
  activityPreferences,
  healthProfiles,
  dailyActivities,
  healthIntegrations,
  healthSessions,
  type User,
  type UpsertUser,
  type ActivityPreference,
  type UpsertActivityPreference,
  type HealthProfile,
  type UpsertHealthProfile,
  type DailyActivity,
  type UpsertDailyActivity,
  type HealthIntegration,
  type UpsertHealthIntegration,
  type HealthSession,
  type UpsertHealthSession,
} from "../shared/schema.js";
import { db } from "./db.js";
import { eq, and, gte, lte, desc, asc } from "drizzle-orm";

// Interface for storage operations
export interface IStorage {
  // User operations
  // (IMPORTANT) these user operations are mandatory for Replit Auth.
  getUser(id: string): Promise<User | undefined>;
  upsertUser(user: UpsertUser): Promise<User>;
  // Activity preferences operations
  saveActivityPreferences(userId: string, preferences: UpsertActivityPreference[]): Promise<ActivityPreference[]>;
  getUserActivityPreferences(userId: string): Promise<ActivityPreference[]>;
  
  // Health profile operations
  getHealthProfile(userId: string): Promise<HealthProfile | undefined>;
  upsertHealthProfile(profileData: UpsertHealthProfile): Promise<HealthProfile>;
  
  // Daily activities operations
  getDailyActivity(userId: string, date: Date): Promise<DailyActivity | undefined>;
  saveDailyActivity(activityData: UpsertDailyActivity): Promise<DailyActivity>;
  getDailyActivitiesRange(userId: string, startDate: Date, endDate: Date): Promise<DailyActivity[]>;
  getRecentDailyActivities(userId: string, limit?: number): Promise<DailyActivity[]>;
  
  // Health integrations operations
  getHealthIntegrations(userId: string): Promise<HealthIntegration[]>;
  getHealthIntegration(userId: string, serviceName: string): Promise<HealthIntegration | undefined>;
  saveHealthIntegration(integrationData: UpsertHealthIntegration): Promise<HealthIntegration>;
  deleteHealthIntegration(userId: string, serviceName: string): Promise<boolean>;
  updateHealthIntegrationSync(userId: string, serviceName: string): Promise<boolean>;
  
  // Health sessions operations
  saveHealthSession(sessionData: UpsertHealthSession): Promise<HealthSession>;
  getHealthSessions(userId: string, limit?: number): Promise<HealthSession[]>;
  getHealthSessionsRange(userId: string, startDate: Date, endDate: Date): Promise<HealthSession[]>;
  getHealthSession(sessionId: string): Promise<HealthSession | undefined>;
  deleteHealthSession(sessionId: string, userId: string): Promise<boolean>;
}

export class DatabaseStorage implements IStorage {
  // User operations
  // (IMPORTANT) these user operations are mandatory for Replit Auth.

  async getUser(id: string): Promise<User | undefined> {
    const [user] = await db.select().from(users).where(eq(users.id, id));
    return user;
  }

  async upsertUser(userData: UpsertUser): Promise<User> {
    const [user] = await db
      .insert(users)
      .values(userData)
      .onConflictDoUpdate({
        target: users.id,
        set: {
          ...userData,
          updatedAt: new Date(),
        },
      })
      .returning();
    return user;
  }

  // Activity preferences operations
  async saveActivityPreferences(userId: string, preferences: UpsertActivityPreference[]): Promise<ActivityPreference[]> {
    // First, delete existing preferences for this user
    await db.delete(activityPreferences).where(eq(activityPreferences.userId, userId));
    
    // Insert new preferences
    if (preferences.length === 0) {
      return [];
    }
    
    const preferencesWithUserId = preferences.map(pref => ({
      ...pref,
      userId,
    }));
    
    const results = await db.insert(activityPreferences)
      .values(preferencesWithUserId)
      .returning();
    
    return results;
  }

  async getUserActivityPreferences(userId: string): Promise<ActivityPreference[]> {
    return await db.select().from(activityPreferences).where(eq(activityPreferences.userId, userId));
  }

  // Health profile operations
  async getHealthProfile(userId: string): Promise<HealthProfile | undefined> {
    const [profile] = await db.select().from(healthProfiles).where(eq(healthProfiles.userId, userId));
    return profile;
  }

  async upsertHealthProfile(profileData: UpsertHealthProfile): Promise<HealthProfile> {
    const [profile] = await db
      .insert(healthProfiles)
      .values({
        ...profileData,
        updatedAt: new Date(),
      })
      .onConflictDoUpdate({
        target: healthProfiles.userId,
        set: {
          ...profileData,
          updatedAt: new Date(),
        },
      })
      .returning();
    return profile;
  }

  // Daily activities operations
  async getDailyActivity(userId: string, date: Date): Promise<DailyActivity | undefined> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const [activity] = await db
      .select()
      .from(dailyActivities)
      .where(
        and(
          eq(dailyActivities.userId, userId),
          gte(dailyActivities.date, startOfDay),
          lte(dailyActivities.date, endOfDay)
        )
      );
    return activity;
  }

  async saveDailyActivity(activityData: UpsertDailyActivity): Promise<DailyActivity> {
    // Use upsert with proper date handling
    const activityDate = new Date(activityData.date!);
    // Normalize to start of day for consistency
    activityDate.setHours(0, 0, 0, 0);
    
    const [activity] = await db
      .insert(dailyActivities)
      .values({
        ...activityData,
        date: activityDate,
        updatedAt: new Date(),
      })
      .onConflictDoUpdate({
        target: [dailyActivities.userId, dailyActivities.date],
        set: {
          ...activityData,
          date: activityDate,
          updatedAt: new Date(),
        },
      })
      .returning();
    return activity;
  }

  async getDailyActivitiesRange(userId: string, startDate: Date, endDate: Date): Promise<DailyActivity[]> {
    return await db
      .select()
      .from(dailyActivities)
      .where(
        and(
          eq(dailyActivities.userId, userId),
          gte(dailyActivities.date, startDate),
          lte(dailyActivities.date, endDate)
        )
      )
      .orderBy(asc(dailyActivities.date));
  }

  async getRecentDailyActivities(userId: string, limit: number = 30): Promise<DailyActivity[]> {
    return await db
      .select()
      .from(dailyActivities)
      .where(eq(dailyActivities.userId, userId))
      .orderBy(desc(dailyActivities.date))
      .limit(limit);
  }

  // Health integrations operations
  async getHealthIntegrations(userId: string): Promise<HealthIntegration[]> {
    const integrations = await db
      .select()
      .from(healthIntegrations)
      .where(eq(healthIntegrations.userId, userId))
      .orderBy(asc(healthIntegrations.serviceName));
    
    // Decrypt tokens for response
    return integrations.map(integration => ({
      ...integration,
      accessToken: integration.accessToken ? this.decryptToken(integration.accessToken) : null,
      refreshToken: integration.refreshToken ? this.decryptToken(integration.refreshToken) : null,
    }));
  }

  async getHealthIntegration(userId: string, serviceName: string): Promise<HealthIntegration | undefined> {
    const [integration] = await db
      .select()
      .from(healthIntegrations)
      .where(
        and(
          eq(healthIntegrations.userId, userId),
          eq(healthIntegrations.serviceName, serviceName)
        )
      );
    
    if (!integration) {
      return undefined;
    }
    
    // Decrypt tokens for response
    return {
      ...integration,
      accessToken: integration.accessToken ? this.decryptToken(integration.accessToken) : null,
      refreshToken: integration.refreshToken ? this.decryptToken(integration.refreshToken) : null,
    };
  }

  async saveHealthIntegration(integrationData: UpsertHealthIntegration): Promise<HealthIntegration> {
    // Encrypt sensitive tokens before storing
    const encryptedData = {
      ...integrationData,
      accessToken: integrationData.accessToken ? this.encryptToken(integrationData.accessToken) : null,
      refreshToken: integrationData.refreshToken ? this.encryptToken(integrationData.refreshToken) : null,
      updatedAt: new Date(),
    };
    
    const [integration] = await db
      .insert(healthIntegrations)
      .values(encryptedData)
      .onConflictDoUpdate({
        target: [healthIntegrations.userId, healthIntegrations.serviceName],
        set: encryptedData,
      })
      .returning();
    
    // Decrypt tokens for response
    return {
      ...integration,
      accessToken: integration.accessToken ? this.decryptToken(integration.accessToken) : null,
      refreshToken: integration.refreshToken ? this.decryptToken(integration.refreshToken) : null,
    };
  }

  async deleteHealthIntegration(userId: string, serviceName: string): Promise<boolean> {
    const result = await db
      .delete(healthIntegrations)
      .where(
        and(
          eq(healthIntegrations.userId, userId),
          eq(healthIntegrations.serviceName, serviceName)
        )
      );
    return result.rowCount > 0;
  }

  async updateHealthIntegrationSync(userId: string, serviceName: string): Promise<boolean> {
    const result = await db
      .update(healthIntegrations)
      .set({
        lastSyncAt: new Date(),
        updatedAt: new Date(),
      })
      .where(
        and(
          eq(healthIntegrations.userId, userId),
          eq(healthIntegrations.serviceName, serviceName)
        )
      );
    return result.rowCount > 0;
  }

  // Health sessions operations
  async saveHealthSession(sessionData: UpsertHealthSession): Promise<HealthSession> {
    const [session] = await db
      .insert(healthSessions)
      .values({
        ...sessionData,
        updatedAt: new Date(),
      })
      .returning();
    return session;
  }

  async getHealthSessions(userId: string, limit: number = 50): Promise<HealthSession[]> {
    return await db
      .select()
      .from(healthSessions)
      .where(eq(healthSessions.userId, userId))
      .orderBy(desc(healthSessions.startTime))
      .limit(limit);
  }

  async getHealthSessionsRange(userId: string, startDate: Date, endDate: Date): Promise<HealthSession[]> {
    return await db
      .select()
      .from(healthSessions)
      .where(
        and(
          eq(healthSessions.userId, userId),
          gte(healthSessions.startTime, startDate),
          lte(healthSessions.startTime, endDate)
        )
      )
      .orderBy(desc(healthSessions.startTime));
  }

  async getHealthSession(sessionId: string): Promise<HealthSession | undefined> {
    const [session] = await db
      .select()
      .from(healthSessions)
      .where(eq(healthSessions.id, sessionId));
    return session;
  }

  async deleteHealthSession(sessionId: string, userId: string): Promise<boolean> {
    const result = await db
      .delete(healthSessions)
      .where(
        and(
          eq(healthSessions.id, sessionId),
          eq(healthSessions.userId, userId)
        )
      );
    return result.rowCount > 0;
  }

  // Token encryption/decryption methods
  private encryptToken(token: string): string {
    // Simple encryption - in production, use proper encryption library like crypto
    const crypto = require('crypto');
    const algorithm = 'aes-256-cbc';
    const key = process.env.ENCRYPTION_KEY || 'default-key-change-in-production-12345678';
    const keyBuffer = Buffer.from(key.padEnd(32).slice(0, 32));
    const iv = crypto.randomBytes(16);
    
    const cipher = crypto.createCipher(algorithm, keyBuffer);
    let encrypted = cipher.update(token, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    
    return iv.toString('hex') + ':' + encrypted;
  }
  
  private decryptToken(encryptedToken: string): string {
    try {
      const crypto = require('crypto');
      const algorithm = 'aes-256-cbc';
      const key = process.env.ENCRYPTION_KEY || 'default-key-change-in-production-12345678';
      const keyBuffer = Buffer.from(key.padEnd(32).slice(0, 32));
      
      const parts = encryptedToken.split(':');
      if (parts.length !== 2) {
        // Legacy unencrypted token, return as-is
        return encryptedToken;
      }
      
      const iv = Buffer.from(parts[0], 'hex');
      const encryptedText = parts[1];
      
      const decipher = crypto.createDecipher(algorithm, keyBuffer);
      let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
      decrypted += decipher.final('utf8');
      
      return decrypted;
    } catch (error) {
      // If decryption fails, assume it's an unencrypted token
      console.warn('Token decryption failed, returning as-is:', error);
      return encryptedToken;
    }
  }
}

export const storage = new DatabaseStorage();