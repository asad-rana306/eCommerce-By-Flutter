import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Home.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String? _emailId;
  String? _password;
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = List.generate(20, (_) => Star());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade100,
                      Colors.pink.shade200,
                      Colors.pink.shade100,
                    ],
                    begin: Alignment(
                      -1 + _animationController.value,
                      -1,
                    ), // waving
                    end: Alignment(1 - _animationController.value, 1),
                  ),
                ),
              ),
              // Floating stars
              ..._stars.map((star) {
                star.update(_animationController.value);
                return Positioned(
                  left: star.x * MediaQuery.of(context).size.width,
                  top: star.y * MediaQuery.of(context).size.height,
                  child: Icon(Icons.star, size: star.size, color: star.color),
                );
              }),
              // Centered Login Card
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 12,
                      shadowColor: Colors.pinkAccent.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.purple,
                              child: Icon(
                                Icons.login,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Login to continue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Form(
                              key: _formStateKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: validateEmail,
                                    onSaved: (value) => _emailId = value,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailIdController,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.purple,
                                      ),
                                      filled: true,
                                      fillColor: Colors.purple.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.purple,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    validator: validatePassword,
                                    onSaved: (value) => _password = value,
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.purple,
                                      ),
                                      filled: true,
                                      fillColor: Colors.purple.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.purple,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 12),
                            Column(
                              children: [
                                // Login Button centered and full width
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formStateKey.currentState!
                                          .validate()) {
                                        _formStateKey.currentState!.save();
                                        final user = await signIn(
                                          _emailId!,
                                          _password!,
                                        );
                                        if (user != null) {
                                          Fluttertoast.showToast(
                                            msg: "Logged in successfully.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const HomeApp(),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Error while Login.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        193,
                                        155,
                                        39,
                                        176,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 32,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Register link text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const RegistrationPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Register",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (!isGoogleSignIn) {
                                  final user = await googleSignInMethod();
                                  if (user != null) {
                                    Fluttertoast.showToast(
                                      msg: "Logged in successfully.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                    setState(() {
                                      isGoogleSignIn = true;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomeApp(),
                                        ),
                                      );
                                    });
                                  }
                                } else {
                                  await googleSignOut();
                                  setState(() {
                                    isGoogleSignIn = false;
                                    successMessage = '';
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              label: Text(
                                isGoogleSignIn
                                    ? 'Google Logout'
                                    : 'Google Login',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16, // increase vertical padding
                                  horizontal:
                                      32, // add horizontal padding for left/right space
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // slightly more rounded
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<User?> googleSignInMethod() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<void> googleSignOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  void handleError(dynamic error) {
    print(error);
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          setState(() => errorMessage = 'User Not Found!');
          break;
        case 'wrong-password':
          setState(() => errorMessage = 'Wrong Password!');
          break;
        default:
          setState(() => errorMessage = 'Login Error!');
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter Email!';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Enter Valid Email!';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is empty!';
    return null;
  }
}

class Star {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = 10 + Random().nextDouble() * 15;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
      .withOpacity(0.7);
  double speed = 0.2 + Random().nextDouble() * 0.3;

  void update(double animationValue) {
    y -= 0.004 * speed;
    if (y < -0.1) {
      y = 1.1;
      x = Random().nextDouble();
      size = 10 + Random().nextDouble() * 15;
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.7);
    }
  }
}
