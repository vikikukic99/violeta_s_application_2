import { Strategy as OpenIDConnectStrategy } from "@govtechsg/passport-openidconnect";
import passport from "passport";
import session from "express-session";
import type { Express, RequestHandler } from "express";
import connectPg from "connect-pg-simple";
import { storage } from "./storage.js";

export function getSession() {
  const sessionTtl = 7 * 24 * 60 * 60 * 1000; // 1 week
  const pgStore = connectPg(session);
  const sessionStore = new pgStore({
    conString: process.env.DATABASE_URL,
    createTableIfMissing: false,
    ttl: sessionTtl,
    tableName: "sessions",
  });
  return session({
    secret: process.env.SESSION_SECRET!,
    store: sessionStore,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
      maxAge: sessionTtl,
    },
  });
}

export async function setupAuth(app: Express) {
  app.set("trust proxy", 1);
  app.use(getSession());
  app.use(passport.initialize());
  app.use(passport.session());

  // Configure OpenID Connect Strategy with PKCE support
  passport.use('replit', new OpenIDConnectStrategy({
    issuer: process.env.ISSUER_URL ?? 'https://replit.com/oidc',
    authorizationURL: 'https://replit.com/oidc/auth',
    tokenURL: 'https://replit.com/oidc/token',
    userInfoURL: 'https://replit.com/oidc/userinfo',
    clientID: process.env.REPL_ID!,
    clientSecret: process.env.CLIENT_SECRET!,
    callbackURL: '/api/callback',
    scope: ['openid', 'email', 'profile'],
    pkce: "S256", // Enable PKCE with SHA256 method
  }, async function verify(issuer: string, profile: any, done: any) {
    try {
      console.log('Auth verify callback:', { issuer, profile });
      
      // Extract sub from profile
      const sub = profile.id || profile._json?.sub;
      if (!sub) {
        throw new Error('No sub found in profile');
      }
      
      // Upsert user in database using sub as ID
      const userData = {
        id: sub,
        email: profile._json?.email || profile.emails?.[0]?.value || null,
        firstName: profile._json?.first_name || profile.name?.givenName || null,
        lastName: profile._json?.last_name || profile.name?.familyName || null,
        profileImageUrl: profile._json?.profile_image_url || profile.photos?.[0]?.value || null,
      };
      
      const user = await storage.upsertUser(userData);
      console.log('User upserted:', user);
      
      return done(null, user);
    } catch (error) {
      console.error('Auth verify error:', error);
      return done(error);
    }
  }));

  passport.serializeUser((user: any, done) => {
    done(null, user.id);
  });

  passport.deserializeUser(async (id: string, done) => {
    try {
      const user = await storage.getUser(id);
      done(null, user);
    } catch (error) {
      done(error);
    }
  });

  // Auth routes
  app.get("/api/login", passport.authenticate('replit'));

  app.get("/api/callback", 
    passport.authenticate('replit', { failureRedirect: '/api/login' }),
    (req, res) => {
      // Redirect to activity selection screen after successful authentication
      // The registration data will be captured by the frontend and sent via API
      res.redirect('/#/activity_selection_screen');
    }
  );

  app.get("/api/logout", (req, res) => {
    req.logout((err) => {
      if (err) {
        console.error('Logout error:', err);
      }
      res.redirect('/');
    });
  });

  // Update user profile with registration data
  app.post("/api/update-profile", isAuthenticated, async (req, res) => {
    try {
      const { fullName, nickname } = req.body;
      const userId = (req.user as any).id;

      if (!fullName || !nickname) {
        return res.status(400).json({ message: "Full name and nickname are required" });
      }

      // Parse fullName into first and last name
      const names = fullName.split(' ');
      const firstName = names[0] || null;
      const lastName = names.slice(1).join(' ') || null;

      // Update user profile using upsert
      const updatedUser = await storage.upsertUser({
        id: userId,
        firstName,
        lastName,
        email: (req.user as any).email, // Keep existing email
        profileImageUrl: (req.user as any).profileImageUrl, // Keep existing image
      });

      console.log('User profile updated:', updatedUser);
      res.json({ success: true, user: updatedUser });
    } catch (error) {
      console.error('Profile update error:', error);
      res.status(500).json({ message: "Failed to update profile" });
    }
  });
}

export const isAuthenticated: RequestHandler = async (req, res, next) => {
  if (req.isAuthenticated() && req.user) {
    return next();
  }
  return res.status(401).json({ message: "Unauthorized" });
};