# -------------------------
# 1) Builder Stage: Build Android APK
# -------------------------
    FROM cirrusci/flutter:latest AS build-env

    # Configure Git to trust the Flutter SDK directory
    RUN git config --global --add safe.directory /sdks/flutter
    
    # Create a non-root user
    RUN useradd -ms /bin/bash flutteruser 
    
    # Ensure necessary directories exist before changing ownership
    RUN mkdir -p /home/flutteruser/app /home/flutteruser/.pub-cache && \
        chown -R flutteruser:flutteruser /home/flutteruser/app /home/flutteruser/.pub-cache /sdks/flutter
    
    # Set working directory as root (before switching users)
    WORKDIR /home/flutteruser/app
    
    # Copy project files before switching users
    COPY --chown=flutteruser:flutteruser . .
    
    # Switch to non-root user
    USER flutteruser
    
    # Debugging: Verify Flutter works
    RUN flutter doctor
    
    # Clean previous builds
    RUN flutter clean
    
    # Fetch dependencies
    RUN flutter pub get
    
    # Ensure Gradle wrapper is updated to latest version
    RUN cd android && ./gradlew wrapper --gradle-version 8.0
    
    # Build the Flutter app for Android (release APK)
    RUN flutter build apk --release
    
    # -------------------------
    # 2) Final Stage: Artifact Container
    # -------------------------
    FROM alpine:latest
    
    WORKDIR /app
    
    # Copy the release APK from the builder stage
    COPY --from=build-env /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk .
    
    # When the container runs, display where the APK is located.
    CMD ["echo", "Android release APK is located in /app/app-release.apk"]