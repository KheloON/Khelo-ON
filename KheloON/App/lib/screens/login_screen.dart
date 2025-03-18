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
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: "527732239961-mhv66eilhu0jtav6pue05ca30qt39ck5.apps.googleusercontent.com",
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
                    width: 400,
                    height:250,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color:Color(0xFFA7E6F8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: const Color.fromARGB(134, 47, 44, 44), blurRadius: 4, spreadRadius: 5),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            style: TextStyle(color: const Color.fromARGB(255, 10, 9, 9)),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 18, 18, 18)),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email, color: const Color.fromARGB(255, 17, 16, 16)),
                            ),
                            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: const Color.fromARGB(255, 14, 13, 13)),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 24, 23, 23)),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 10, 10, 10)),
                            ),
                            validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                          ),
                          SizedBox(height: 20),
                          isLoading
                              ? Lottie.asset('lib/assets/animations/running_man.json', width: 80, height: 80)
                              : ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ?? false) {
                                      _emailSignIn();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 20, 20, 20),
                                    foregroundColor: const Color.fromARGB(255, 244, 239, 239),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  child: Text('Sign in with Email'),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _googleSignIn,
                    icon: Image.asset('lib/assets/google_logo.png', height: 24),
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 14, 14, 14),
                      foregroundColor: const Color.fromARGB(255, 244, 243, 243),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccountScreen())),
                    child: Text('Create New Account', style: TextStyle(color: const Color.fromARGB(255, 15, 14, 14), fontSize: 16)),
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