# -------------------------
# 1) Builder Stage: Build Android APK
# -------------------------
    FROM cirrusci/flutter:latest AS build-env

    # Configure Git to trust the Flutter SDK directory
    RUN git config --global --add safe.directory /sdks/flutter
    
    # Create a non-root user and update ownership of the Flutter SDK.
    RUN useradd -ms /bin/bash flutteruser && \
        sudo chown -R flutteruser:flutteruser /sdks/flutter
    
    # Switch to the non-root user.
    USER flutteruser
    
    # Set the working directory.
    WORKDIR /home/flutteruser/app
    
    # Copy all project files into the container.
    COPY . .
    
    # (Removed: RUN flutter channel stable)
    
    # Upgrade Flutter to update Dart (this will switch to the latest stable if needed)
    # RUN flutter upgrade
    
    # Clean previous builds.
    RUN flutter clean
    
    # Fetch dependencies with the updated Dart SDK.
    RUN flutter pub get
    
    # Build the Flutter app for Android (release APK).
    RUN flutter build apk --release
    
    # -------------------------
    # 2) Final Stage: Artifact Container
    # -------------------------
    FROM alpine:latest
    WORKDIR /app
    
    # Copy the release APK from the builder stage.
    COPY --from=build-env /home/flutteruser/app/build/app/outputs/flutter-apk/app-release.apk .
    
    # When the container runs, display where the APK is located.
    CMD ["echo", "Android release APK is located in /app/app-release.apk"]