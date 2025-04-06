import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:athlete/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:athlete/screens/onboarding_screen.dart';
import 'package:athlete/screens/create_account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId: "1036369602559-4s0sg2jgmp7ocn3chp6c19mtrhkp2b8f.apps.googleusercontent.com",
    scopes: ['email'],
  );

  Future<void> _googleSignIn() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => isFirstTime ? OnboardingScreen() : HomeScreen()),
      );
    } catch (error) {
      debugPrint("Google Sign-In failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _emailSignIn() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnboardingScreen()));
    } catch (error) {
      debugPrint("Email Sign-In failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email Sign-In failed")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'lib/assets/animations/login.json',
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 234, 233),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 6, spreadRadius: 2),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email, color: Colors.black),
                            ),
                            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                            ),
                            validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? Lottie.asset('lib/assets/animations/running_man.json', width: 80, height: 80)
                              : ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ?? false) {
                                      _emailSignIn();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                                  ),
                                  child: Text(
                                    'Sign in with Email',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _googleSignIn,
                    icon: Image.asset('lib/assets/google_logo.png', height: 24),
                    label: const Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccountScreen())),
                    child: Text(
                      'Create New Account',
                      style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
