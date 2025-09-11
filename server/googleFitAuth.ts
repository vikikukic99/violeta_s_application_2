import passport from 'passport';
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import { storage } from './storage.js';
import type { Express } from 'express';

// Google Fit API scopes for health data access
const GOOGLE_FIT_SCOPES = [
  'profile',
  'email',
  'https://www.googleapis.com/auth/fitness.activity.read',
  'https://www.googleapis.com/auth/fitness.body.read',
  'https://www.googleapis.com/auth/fitness.heart_rate.read',
  'https://www.googleapis.com/auth/fitness.location.read',
  'https://www.googleapis.com/auth/fitness.sleep.read',
];

/**
 * Google Fit authentication strategy setup
 */
export function setupGoogleFitAuth() {
  if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
    console.warn('Google OAuth credentials not configured. Google Fit integration will be disabled.');
    return;
  }

  passport.use('google-fit', new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID!,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    callbackURL: '/api/auth/google-fit/callback',
    scope: GOOGLE_FIT_SCOPES,
  }, async (accessToken: string, refreshToken: string, profile: any, done: any) => {
    try {
      console.log('Google Fit OAuth callback:', { 
        profileId: profile.id,
        hasAccessToken: !!accessToken,
        hasRefreshToken: !!refreshToken 
      });

      // Return the tokens and profile data
      // The actual integration saving will be handled in the route
      return done(null, {
        profile,
        accessToken,
        refreshToken,
        tokenExpiresAt: new Date(Date.now() + (3600 * 1000)), // 1 hour default
      });
    } catch (error) {
      console.error('Error in Google Fit OAuth callback:', error);
      return done(error, null);
    }
  }));
}

/**
 * Google Fit authentication routes
 */
export function setupGoogleFitRoutes(app: Express) {
  if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
    // Add disabled route for when credentials are not configured
    app.get('/api/auth/google-fit/connect', (req, res) => {
      res.status(503).json({ 
        message: 'Google Fit integration is not configured. Please set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET environment variables.' 
      });
    });
    return;
  }

  // Initiate Google Fit OAuth flow
  app.get('/api/auth/google-fit/connect', (req: any, res, next) => {
    // Store the user ID in session for the callback
    if (req.user) {
      req.session.userId = req.user.id;
    }
    
    passport.authenticate('google-fit', {
      accessType: 'offline',
      prompt: 'consent', // Force consent to get refresh token
    })(req, res, next);
  });

  // Google Fit OAuth callback
  app.get('/api/auth/google-fit/callback',
    passport.authenticate('google-fit', { session: false }),
    async (req: any, res) => {
      try {
        const userId = req.session.userId;
        const authData = req.user;

        if (!userId) {
          return res.status(400).json({ message: 'User session not found. Please login first.' });
        }

        if (!authData) {
          return res.status(400).json({ message: 'Google authentication failed.' });
        }

        // Save Google Fit integration to database
        const integrationData = {
          userId: userId,
          serviceName: 'google_fit',
          isActive: true,
          accessToken: authData.accessToken,
          refreshToken: authData.refreshToken,
          tokenExpiresAt: authData.tokenExpiresAt,
          settings: {
            googleUserId: authData.profile.id,
            email: authData.profile.emails?.[0]?.value,
            name: authData.profile.displayName,
            scopes: GOOGLE_FIT_SCOPES,
          },
        };

        await storage.saveHealthIntegration(integrationData);

        console.log('Google Fit integration saved successfully for user:', userId);
        
        // Redirect to health data connection screen in the Flutter app
        res.redirect('/#/health_data_connection_screen?status=success&service=google_fit');
      } catch (error) {
        console.error('Error saving Google Fit integration:', error);
        res.redirect('/#/health_data_connection_screen?status=error&service=google_fit');
      }
    }
  );

  // Disconnect Google Fit integration
  app.delete('/api/auth/google-fit/disconnect', async (req: any, res) => {
    try {
      if (!req.user) {
        return res.status(401).json({ message: 'Authentication required' });
      }

      const deleted = await storage.deleteHealthIntegration(req.user.id, 'google_fit');
      
      if (!deleted) {
        return res.status(404).json({ message: 'Google Fit integration not found' });
      }

      res.json({ message: 'Google Fit integration disconnected successfully' });
    } catch (error) {
      console.error('Error disconnecting Google Fit integration:', error);
      res.status(500).json({ message: 'Failed to disconnect Google Fit integration' });
    }
  });

  // Get Google Fit integration status
  app.get('/api/auth/google-fit/status', async (req: any, res) => {
    try {
      if (!req.user) {
        return res.status(401).json({ message: 'Authentication required' });
      }

      const integration = await storage.getHealthIntegration(req.user.id, 'google_fit');
      
      if (!integration) {
        return res.json({ connected: false });
      }

      res.json({
        connected: true,
        isActive: integration.isActive,
        lastSyncAt: integration.lastSyncAt,
        settings: integration.settings,
        tokenExpiresAt: integration.tokenExpiresAt,
      });
    } catch (error) {
      console.error('Error getting Google Fit status:', error);
      res.status(500).json({ message: 'Failed to get Google Fit status' });
    }
  });
}

/**
 * Sync health data from Google Fit API
 * This is a utility function that can be called by a cron job or on-demand
 */
export async function syncGoogleFitData(userId: string): Promise<boolean> {
  try {
    const integration = await storage.getHealthIntegration(userId, 'google_fit');
    
    if (!integration || !integration.isActive || !integration.accessToken) {
      console.log('Google Fit integration not found or inactive for user:', userId);
      return false;
    }

    // Check if token is expired and needs refresh
    const now = new Date();
    if (integration.tokenExpiresAt && integration.tokenExpiresAt < now) {
      console.log('Google Fit token expired for user:', userId);
      // TODO: Implement token refresh logic
      return false;
    }

    // TODO: Implement actual Google Fit API calls here
    // This would include fetching:
    // - Daily step counts
    // - Activity sessions (workouts, runs, etc.)
    // - Heart rate data
    // - Sleep data
    // - Distance and calories burned

    console.log('Google Fit data sync placeholder for user:', userId);
    
    // Update last sync timestamp
    await storage.updateHealthIntegrationSync(userId, 'google_fit');
    
    return true;
  } catch (error) {
    console.error('Error syncing Google Fit data for user', userId, ':', error);
    return false;
  }
}

/**
 * Refresh Google OAuth token
 */
export async function refreshGoogleFitToken(userId: string): Promise<boolean> {
  try {
    const integration = await storage.getHealthIntegration(userId, 'google_fit');
    
    if (!integration || !integration.refreshToken) {
      console.log('Google Fit integration or refresh token not found for user:', userId);
      return false;
    }

    // TODO: Implement token refresh using Google OAuth2 API
    console.log('Google Fit token refresh placeholder for user:', userId);
    
    return true;
  } catch (error) {
    console.error('Error refreshing Google Fit token for user', userId, ':', error);
    return false;
  }
}