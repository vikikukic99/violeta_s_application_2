import {
  users,
  activityPreferences,
  type User,
  type UpsertUser,
  type ActivityPreference,
  type UpsertActivityPreference,
} from "../shared/schema.js";
import { db } from "./db.js";
import { eq } from "drizzle-orm";

// Interface for storage operations
export interface IStorage {
  // User operations
  // (IMPORTANT) these user operations are mandatory for Replit Auth.
  getUser(id: string): Promise<User | undefined>;
  upsertUser(user: UpsertUser): Promise<User>;
  // Activity preferences operations
  saveActivityPreferences(userId: string, preferences: UpsertActivityPreference[]): Promise<ActivityPreference[]>;
  getUserActivityPreferences(userId: string): Promise<ActivityPreference[]>;
  // Other operations
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

  // Other operations can be added here as needed
}

export const storage = new DatabaseStorage();