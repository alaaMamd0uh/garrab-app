import 'package:firebase_auth/firebase_auth.dart'; // [NEW]
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:garrib_app/core/services/auth_service.dart'; // [NEW]
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/core/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // [NEW] Service that creates the account in Auth and saves data in Firestore
  final _authService = AuthService();

  // [NEW] Prevents double taps while the request is running
  bool _isLoading = false;

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // [NEW] Real registration (replaces the fake "Registering..." snackbar)
  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // [NEW] Creates the Auth account + a document in the "users" collection
      await _authService.register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      // [NEW] Go to Login and clear all previous screens (Login + Signup)
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // [NEW] Show a friendly error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthService.errorMessage(e))),
      );
    } finally {
      // [NEW] Always stop the loading state
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 33),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(248, 242, 242, 242),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: AppColors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  'Hello!',
                  style: AppStyles.heading1.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sign up to get started',
                  style: AppStyles.bodySmall.copyWith(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 35),

                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.black),
                  decoration: _buildInputDecoration(hintText: 'User Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your user name';
                    }
                    if (value.trim().length < 3) {
                      return 'User name must be at least 3 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.black),
                  decoration: _buildInputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.black),
                  decoration: _buildInputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.terracotta,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    // [NEW] Show loading text and ignore taps while loading
                    text: _isLoading ? 'Loading...' : 'Register',
                    width: double.infinity,
                    onPressed: _isLoading ? () {} : _submitRegister,
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    const Expanded(
                        child: Divider(
                            color: Color.fromARGB(99, 0, 0, 0), thickness: 0.8)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Expanded(
                        child: Divider(color: Colors.black26, thickness: 0.8)),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      image: 'assets/images/google_icon.png',
                      size: 50,
                      onTap: () {},
                    ),
                    const SizedBox(width: 32),
                    _buildSocialButton(
                      image: 'assets/images/facebook_icon.png',
                      size: 48,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.black,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.terracotta,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.maybePop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppStyles.bodySmall.copyWith(
        color: Colors.black38,
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color.fromARGB(248, 241, 241, 241),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.terracotta, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }

  Widget _buildSocialButton({
    required String image,
    required double size,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          image,
          width: size,
          height: size,
        ),
      ),
    );
  }
}