import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // [NEW] Keep the timer so we can cancel it if the screen is closed early
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // [NEW] Single timer (the old nested Timer + Future.delayed was removed)
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      // [NEW] Check if a user session is already saved on the device
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // [NEW] Already logged in -> go straight to MainLayout
        Navigator.pushReplacementNamed(context, '/mainlayout');
      } else {
        // [NEW] Not logged in -> normal flow (Onboarding then Login)
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    // [NEW] Cancel the timer to avoid running it after the screen is gone
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/black_logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 80),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFC86D51),
              ),
            ),
          ],
        ),
      ),
    );
  }
}