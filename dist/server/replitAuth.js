import { Strategy as OpenIDConnectStrategy } from "passport-openidconnect";
import passport from "passport";
import session from "express-session";
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
        secret: process.env.SESSION_SECRET,
        store: sessionStore,
        resave: false,
        saveUninitialized: false,
        cookie: {
            httpOnly: true,
            secure: true,
            maxAge: sessionTtl,
        },
    });
}
export async function setupAuth(app) {
    app.set("trust proxy", 1);
    app.use(getSession());
    app.use(passport.initialize());
    app.use(passport.session());
    // Configure OpenID Connect Strategy
    passport.use('replit', new OpenIDConnectStrategy({
        issuer: process.env.ISSUER_URL ?? 'https://replit.com/oidc',
        authorizationURL: 'https://replit.com/oidc/auth',
        tokenURL: 'https://replit.com/oidc/token',
        userInfoURL: 'https://replit.com/oidc/userinfo',
        clientID: process.env.REPL_ID,
        clientSecret: process.env.CLIENT_SECRET,
        callbackURL: '/api/callback',
        scope: ['openid', 'email', 'profile'],
    }, async function verify(issuer, profile, done) {
        try {
            // Upsert user in database
            const user = await storage.upsertUser({
                id: profile.id,
                email: profile.emails?.[0]?.value || null,
                firstName: profile.name?.givenName || null,
                lastName: profile.name?.familyName || null,
                profileImageUrl: profile.photos?.[0]?.value || null,
            });
            return done(null, { ...user, profile });
        }
        catch (error) {
            return done(error);
        }
    }));
    passport.serializeUser((user, done) => {
        done(null, user.id);
    });
    passport.deserializeUser(async (id, done) => {
        try {
            const user = await storage.getUser(id);
            done(null, user);
        }
        catch (error) {
            done(error);
        }
    });
    // Auth routes
    app.get("/api/login", passport.authenticate('replit'));
    app.get("/api/callback", passport.authenticate('replit', { failureRedirect: '/api/login' }), (req, res) => {
        res.redirect('/');
    });
    app.get("/api/logout", (req, res) => {
        req.logout((err) => {
            if (err) {
                console.error('Logout error:', err);
            }
            res.redirect('/');
        });
    });
}
export const isAuthenticated = async (req, res, next) => {
    if (req.isAuthenticated() && req.user) {
        return next();
    }
    return res.status(401).json({ message: "Unauthorized" });
};
