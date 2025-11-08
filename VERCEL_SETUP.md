# Vercel Deployment Setup

This document explains how to configure environment variables for deploying the Palestinian Ministry of Endowments app to Vercel.

## Overview

The app uses environment variables for configuration. For local development, these are loaded from a `.env` file. For Vercel deployment, they must be configured in the Vercel dashboard.

## Required Environment Variables

Set these in your Vercel project dashboard:

### 1. Supabase Configuration (REQUIRED)

```
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key-here
```

Get these from: https://app.supabase.com/project/_/settings/api

### 2. Google Maps API (REQUIRED)

```
GOOGLE_MAPS_API_KEY=your-google-maps-api-key-here
```

Get this from: https://console.cloud.google.com/google/maps-apis

### 3. Firebase Configuration (REQUIRED)

```
FIREBASE_PROJECT_ID=your-firebase-project-id
```

Get this from: https://console.firebase.google.com/project/_/settings/general

### 4. Environment (OPTIONAL)

```
ENVIRONMENT=production
```

Options: `development`, `staging`, `production`
Default: `production` (if not set)

## How to Set Environment Variables in Vercel

1. Go to your Vercel project dashboard
2. Navigate to **Settings** → **Environment Variables**
3. Add each environment variable:
   - Enter the **Key** (e.g., `SUPABASE_URL`)
   - Enter the **Value** (e.g., `https://your-project.supabase.co`)
   - Select which environments to apply to (Production, Preview, Development)
   - Click **Save**

## Build Process

The build script (`build.sh`) automatically passes environment variables to the Flutter build using `--dart-define` flags:

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
  --dart-define=GOOGLE_MAPS_API_KEY="${GOOGLE_MAPS_API_KEY}" \
  --dart-define=FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID}" \
  --dart-define=ENVIRONMENT="${ENVIRONMENT}"
```

## Troubleshooting

### Error: "String.fromEnvironment can only be used as a const constructor"

This error occurs when environment variables are not properly passed during build. Ensure:
- All required environment variables are set in Vercel dashboard
- The build script is using `--dart-define` flags
- You're not using runtime `String.fromEnvironment()` with variable keys

### Error: "Required environment variable is not set"

This means a required environment variable is missing. Check:
- Vercel dashboard has all required variables
- Variable names match exactly (case-sensitive)
- Variables are enabled for the correct environment (Production/Preview)

### App fails to initialize Supabase

- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are correct
- Check Supabase project is active and accessible
- Ensure there are no typos in the environment variable values

## Security Notes

- **NEVER** commit `.env` file to git
- Use different credentials for development/staging/production
- Rotate keys immediately if accidentally exposed
- Store production secrets only in Vercel's environment variables
- Enable Vercel's "Encrypted" option for sensitive values

## Redeploy After Changes

After updating environment variables in Vercel:
1. Go to **Deployments**
2. Find the latest deployment
3. Click the **⋯** menu
4. Select **Redeploy**
5. Ensure "Use existing Build Cache" is **unchecked**

This ensures the new environment variables are included in the build.
