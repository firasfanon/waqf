#!/bin/bash
set -e

# Download and extract Flutter 3.35.7 (matches local environment)
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.7-stable.tar.xz | tar -xJ -C /tmp

# Add Flutter to PATH
export PATH="/tmp/flutter/bin:$PATH"

# Fix git ownership
git config --global --add safe.directory /tmp/flutter

# Configure Flutter
flutter config --enable-web --no-analytics

# Verify version
flutter --version

# Get dependencies
flutter pub get

# Build web with environment variables passed as dart-define
# Vercel automatically provides environment variables set in the dashboard
echo "Building with environment variables..."
flutter build web --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
  --dart-define=GOOGLE_MAPS_API_KEY="${GOOGLE_MAPS_API_KEY:-}" \
  --dart-define=FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-}" \
  --dart-define=ENVIRONMENT="${ENVIRONMENT:-production}"