import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _errorMessage = '';
  String _successMessage = '';

  late AnimationController _animationController;
  late List<Balloon> _balloons;

  @override
  void initState() {
    super.initState();
    _balloons = List.generate(15, (index) => Balloon());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              // Gradient background animation
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.shade100,
                      Colors.lightGreenAccent.shade400,
                      Colors.tealAccent.shade100,
                    ],
                    begin: Alignment(-1 + _animationController.value, -1),
                    end: Alignment(1 - _animationController.value, 1),
                  ),
                ),
              ),
              // Floating balloons
              ..._balloons.map((balloon) {
                balloon.update(_animationController.value);
                return Positioned(
                  left: balloon.x * MediaQuery.of(context).size.width,
                  top: balloon.y * MediaQuery.of(context).size.height,
                  child: Icon(
                    Icons.circle,
                    size: balloon.size,
                    color: balloon.color,
                  ),
                );
              }),
              // Registration form card
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 12,
                      shadowColor: Colors.greenAccent.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.person_add_alt_1,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Join us! It's fun and easy",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Form
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.green,
                                      ),
                                      filled: true,
                                      fillColor: Colors.green[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: _validateEmail,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.green,
                                      ),
                                      filled: true,
                                      fillColor: Colors.green[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: _validatePassword,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: "Confirm Password",
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.green,
                                      ),
                                      filled: true,
                                      fillColor: Colors.green[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: _validateConfirmPassword,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Error and success messages
                            if (_errorMessage.isNotEmpty)
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            if (_successMessage.isNotEmpty)
                              Text(
                                _successMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),

                            const SizedBox(height: 24),

                            // Register button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _registerUser,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 6,
                                  shadowColor: Colors.greenAccent,
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // "Already have account? Login"
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
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

  Future<void> _registerUser() async {
    setState(() {
      _errorMessage = '';
      _successMessage = '';
    });

    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        if (userCredential.user != null) {
          Fluttertoast.showToast(
            msg: "Registration successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          setState(() {
            _successMessage =
                "Registered Successfully! You can now login to your account.";
          });
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = "Email already exists!";
            break;
          case 'invalid-email':
            _errorMessage = "Invalid email address!";
            break;
          case 'weak-password':
            _errorMessage = "Password is too weak!";
            break;
          default:
            _errorMessage = e.message ?? "Registration failed!";
        }
        setState(() {});
      } catch (e) {
        setState(() {
          _errorMessage = "An error occurred. Try again.";
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    final regex = RegExp(
      r'^([a-zA-Z0-9_\.\-])+\@([a-zA-Z0-9\-]+\.)+([a-zA-Z0-9]{2,4})+$',
    );
    if (!regex.hasMatch(value)) return "Enter valid email";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (value.length < 3 || value.length > 14) {
      return "Password must be 3-14 characters";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Confirm password";
    if (value != _passwordController.text.trim()) {
      return "Passwords do not match";
    }
    return null;
  }
}

class Balloon {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = 20 + Random().nextDouble() * 30;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
      .withOpacity(0.7);
  double speed = 0.2 + Random().nextDouble() * 0.3;

  void update(double animationValue) {
    y -= 0.005 * speed;
    if (y < -0.1) {
      y = 1.1;
      x = Random().nextDouble();
      size = 20 + Random().nextDouble() * 30;
      color = Colors.primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.7);
    }
  }
}
