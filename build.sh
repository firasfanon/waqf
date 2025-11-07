#!/bin/bash
set -e

# Download Flutter 3.27.0 (has newer Dart)
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz | tar -xJ -C /tmp

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

# Build web
flutter build web --release