import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/core/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in...')),
      );
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
                
                // InkWell(
                //   onTap: () => Navigator.maybePop(context),
                //   borderRadius: BorderRadius.circular(30),
                //   child: Container(
                //     padding: const EdgeInsets.all(12),
                //     decoration: BoxDecoration(
                //       color: const Color.fromARGB(248, 242, 242, 242),
                //       shape: BoxShape.circle,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.04),
                //           blurRadius: 1,
                //           offset: const Offset(0, 2),
                //         ),
                //       ],
                //     ),
                //     child: const Icon(
                //       Icons.arrow_back_ios_new,
                //       size: 18,
                //       color: AppColors.black,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 60),

                Text(
                  'Welcome!',
                  style: AppStyles.heading1.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We missed having you here',
                  style: AppStyles.bodySmall.copyWith(
                    fontSize: 20,
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 45),

                
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.black),
                  decoration: _buildInputDecoration(hintText: 'Enter your Email'),
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
                    hintText: 'Enter your Password',
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

                const SizedBox(height: 12),

                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forget password?',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.terracotta,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

              
                SizedBox(
                  // width: double.infinity,
                  // height: 54,
                  // child: ElevatedButton(
                  //   onPressed: _submitLogin,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.black,
                  //     elevation: 4,
                  //     shadowColor: Colors.black26,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(14),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     'Login',
                  //     style: AppStyles.bodySmall.copyWith(
                  //       color: Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  child: CustomButton(
                    text: 'Login',
                  
                    width: double.infinity,
                      onPressed: _submitLogin,
                  ),
                ),

                const SizedBox(height: 32),

                
                Row(
                  children: [
                        const Expanded(child: Divider(color: Color.fromARGB(99, 0, 0, 0), thickness: 0.8)),
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
                    const Expanded(child: Divider(color: Colors.black26, thickness: 0.8)),
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
      text: "Don’t have an account? ",
      style: AppStyles.bodySmall.copyWith(
        color: AppColors.black,
        fontSize: 15,
      ),
      children: [
        TextSpan(
          text: 'Register',
          style: AppStyles.bodySmall.copyWith(
            color: AppColors.terracotta,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, '/register'); 
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