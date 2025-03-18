import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('This platform is not supported.');
    }
  }

  // Web platform options
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyB-jdWE5gDTKjPtMYoe9FZiODksr343p6w",
    authDomain: "athleticon-3f65f.firebaseapp.com",
    projectId: "athleticon-3f65f",
    storageBucket: "athleticon-3f65f.appspot.com",
    messagingSenderId: "527732239961",
    appId: "1:527732239961:web:4347809681f50250028b48",
    measurementId: "G-4396RMQKY9",
  );

  // Android platform options
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAAXu8nu6ll1Li2V3gO9Q59nKm7e1vmN5s",
    authDomain: "athleticon-3f65f.firebaseapp.com",
    projectId: "athleticon-3f65f",
    storageBucket: "athleticon-3f65f.appspot.com",
    messagingSenderId: "527732239961",
    appId: "1:527732239961:android:b1dbfc79fd4eeb8f028b48",
  );

  // iOS platform options
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAAXu8nu6ll1Li2V3gO9Q59nKm7e1vmN5s",
    authDomain: "athleticon-3f65f.firebaseapp.com",
    projectId: "athleticon-3f65f",
    storageBucket: "athleticon-3f65f.appspot.com",
    messagingSenderId: "527732239961",
    appId: "1:527732239961:ios:b1dbfc79fd4eeb8f028b48",
    iosBundleId: "com.company.athleticon",
  );
}
