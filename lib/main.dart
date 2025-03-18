import 'package:flutter/material.dart';
import 'package:athlete/screens/login_screen.dart';
import 'package:athlete/screens/onboarding_screen.dart';
import 'package:athlete/screens/health_screen.dart'; // ✅ Import HealthScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:athlete/services/firebase_options.dart';
import 'package:athlete/screens/main_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase Init Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, bool>> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      return {'isFirstTime': isFirstTime, 'isLoggedIn': isLoggedIn};
    } catch (e) {
      debugPrint("SharedPreferences Error: $e");
      return {'isFirstTime': true, 'isLoggedIn': false};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _loadPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          debugPrint("Error loading preferences: ${snapshot.error}");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text("Error loading app")),
            ),
          );
        }

        final bool isFirstTime = snapshot.data?['isFirstTime'] ?? true;
        final bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;

        debugPrint("Navigation Decision -> isFirstTime: $isFirstTime, isLoggedIn: $isLoggedIn");

        Widget initialScreen;
        if (!isLoggedIn) {
          initialScreen = LoginScreen(); // Always start with login
        } else if (isFirstTime) {
          initialScreen = OnboardingScreen(); // Show onboarding after login
        } else {
          initialScreen = MainScreen(); // If already logged in, go to home
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Athlete App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: initialScreen,
          routes: {
            '/health': (context) => HealthScreen(), // ✅ Added route for HealthScreen
          },
        );
      },
    );
  }
}
