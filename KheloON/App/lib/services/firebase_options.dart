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

  // Web platform options (Updated for KheloON)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyA7Uo5kRkkBwG8Qx4XXd0LhV5BjJciyqS0",
    authDomain: "kheloon.firebaseapp.com",
    projectId: "kheloon",
    storageBucket: "kheloon.firebasestorage.app", // this looks like a typo, double-check below
    messagingSenderId: "1036369602559",
    appId: "1:1036369602559:web:ae3103d3a8697e944de9ca",
    measurementId: null, // add if needed later
  );

  // Android platform options (You’ll still need to update these based on google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDjZ5MftVW0LBHsu--_wd1rijO4jm8252o",
    authDomain: "kheloon.firebaseapp.com",
    projectId: "kheloon",
    storageBucket: "kheloon.appspot.com",
    messagingSenderId: "1036369602559",
    appId: "1:1036369602559:android:d7fae7a000d86bbe4de9ca",
  );

  // iOS platform options (Update if using iOS)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDjZ5MftVW0LBHsu--_wd1rijO4jm8252o",
    authDomain: "kheloon.firebaseapp.com",
    projectId: "kheloon",
    storageBucket: "kheloon.appspot.com",
    messagingSenderId: "1036369602559",
   appId: "1:1036369602559:web:ae3103d3a8697e944de9ca",
    iosBundleId: "com.company.kheloon",
  );
}
