import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garrib_app/features/singup/view/signup.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'package:garrib_app/features/product_details/view/product_details_screen.dart';
import 'package:garrib_app/features/splash/view/spash_screen.dart';
import 'package:garrib_app/main_layout.dart';
import 'package:garrib_app/providers/cart_provider.dart';
import 'package:garrib_app/providers/favorites_provider.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/features/cart/view/cart.dart';
import 'package:garrib_app/features/home/view/home.dart';
import 'package:garrib_app/features/login/view/login_test.dart';
import 'package:garrib_app/features/onbording/view/onbording.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
          '/register': (context) => const SignupScreen(),
        '/mainlayout': (context) => const MainLayout(),
        '/home': (context) =>  HomeScreen(),
        '/cart': (context) => const CartScreen(),
      },
    onGenerateRoute: (settings) {
  if (settings.name == '/ProductDetails') {
    final product = settings.arguments as ProductModel?;

    if (product != null) {
      return MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      );
    }
  }
  return null;
},
    );
  }
}