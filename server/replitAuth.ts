import { Strategy as OpenIDConnectStrategy } from "passport-openidconnect";
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
    usePKCE: true, // Enable PKCE for enhanced security
  }, async function verify(issuer: string, sub: string, profile: any, jwtClaims: any, accessToken: string, refreshToken: string, params: any, done: any) {
    try {
      console.log('Auth verify callback:', { sub, profile: profile?._json });
      
      // Upsert user in database using sub as ID
      const userData = {
        id: sub,
        email: profile?._json?.email || null,
        firstName: profile?._json?.first_name || null,
        lastName: profile?._json?.last_name || null,
        profileImageUrl: profile?._json?.profile_image_url || null,
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
      // Redirect to Flutter app root
      res.redirect('/');
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
}

export const isAuthenticated: RequestHandler = async (req, res, next) => {
  if (req.isAuthenticated() && req.user) {
    return next();
  }
  return res.status(401).json({ message: "Unauthorized" });
};