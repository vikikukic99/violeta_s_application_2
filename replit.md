# Flutter Web Application

## Project Overview
This is a Flutter-based mobile application that has been successfully configured to run as a web application in the Replit environment. The app features activity tracking, chat functionality, user profiles, and various integrations.

## Current State
- ✅ Flutter SDK installed and configured
- ✅ Web platform support enabled  
- ✅ Dependencies installed via `flutter pub get`
- ✅ Development server running on port 5000
- ✅ Production build configuration set up
- ✅ Environment variables configured via env.json asset
- ✅ Deployment ready for production

## Architecture
The application follows standard Flutter architecture patterns:

- **Presentation Layer**: UI screens and widgets in `lib/presentation/`
- **Core Services**: Utilities and app configuration in `lib/core/`
- **API Services**: External service integrations in `lib/services/`
- **State Management**: Flutter Riverpod for state management
- **Routing**: Custom routing system in `lib/routes/`

## Development Setup
- **Development Server**: Flutter web server on port 5000 with proper host configuration (0.0.0.0)
- **Build Process**: `flutter build web --release` for production builds
- **Environment Variables**: Loaded from env.json as a Flutter asset

## Key Features
- Activity selection and tracking
- Chat and messaging system
- User profile management
- Health data integration
- Payment methods
- Privacy settings
- Maps and geolocation services

## Security Notes
- API keys are configured as placeholders in env.json
- For production deployment, sensitive API keys should be managed server-side
- The application is configured to avoid exposing secrets in the client bundle

## Deployment
The application is configured for deployment on Replit with:
- Build command: `flutter build web --release`
- Run command: `python3 -m http.server 5000 -d build/web`
- Target: Autoscale deployment for stateless web applications

## Recent Changes
- **Fixed Navigation & Button Connections** (Latest):
  - Resolved authentication redirect loop issue - users now stay in activity selection
  - Connected all activity selection buttons to backend API
  - Added proper form validation for Continue button (description & location required)
  - Fixed splash screen auth check with mounted state management
  - Complete flow working: Login → Activity Selection → Save to DB → Health Data Connection
- **Added Replit Authentication**: Complete authentication system with user login/logout
  - Express.js backend server with PostgreSQL database
  - Authentication endpoints at /api/login, /api/logout, /api/auth/user, /api/auth/status
  - Session management with secure cookies
  - Activity preferences API at /api/activity-preferences
- **Fixed Registration Screen**: All buttons now functional with proper navigation
  - Create Account button uses clean arrow icon and redirects to login
  - Google and Apple buttons redirect to authentication 
  - Log In link properly navigates to login page
  - Fixed text overflow issues with responsive design
- Configured Flutter web support for Replit environment
- Set up proper host binding for web preview compatibility
- Added env.json to Flutter assets for configuration access
- Established production build pipeline
- Configured deployment settings for Replit hosting

## User Preferences
- Project successfully imported and configured from GitHub
- Web-first deployment approach preferred
- Development environment optimized for Replit workflow