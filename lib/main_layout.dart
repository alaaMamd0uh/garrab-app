import 'package:flutter/material.dart';
import 'package:garrib_app/features/profile/view/profile.dart';
import 'package:garrib_app/providers/cart_provider.dart';
import 'package:garrib_app/search/view/search_screen.dart';
import 'package:provider/provider.dart'; 
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/features/cart/view/cart.dart';
import 'package:garrib_app/features/favorites/view/favorites_screen.dart'; 
import 'package:garrib_app/features/home/view/custom_bottom_nav_bar.dart';
import 'package:garrib_app/features/home/view/home.dart';
import 'package:garrib_app/features/product_details/view/product_details_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final currentNavigator = _navigatorKeys[_currentIndex].currentState;

        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
        } else if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Index 0: Home Navigator
            _buildOffstageNavigator(0, _buildHomeNavigator()),
            
            // Index 1: Cart Screen
            _buildOffstageNavigator(
              1,
              CartScreen(
                onStartShopping: () {
                  setState(() {
                    _currentIndex = 0; 
                  });
                  Future.delayed(const Duration(milliseconds: 150), () {
                    if (_navigatorKeys[0].currentState != null &&
                        _navigatorKeys[0].currentState!.canPop()) {
                      _navigatorKeys[0].currentState?.popUntil((route) => route.isFirst);
                    }
                  });
                },
              ),
            ),

            // Index 2: Favorites Screen
            _buildOffstageNavigator(
              2,
              FavoritesScreen(
                onGoToStore: () {
                  setState(() {
                    _currentIndex = 0; 
                  });
                  Future.delayed(const Duration(milliseconds: 150), () {
                    if (_navigatorKeys[0].currentState != null &&
                        _navigatorKeys[0].currentState!.canPop()) {
                      _navigatorKeys[0].currentState?.popUntil((route) => route.isFirst);
                    }
                  });
                },
              ),
            ),

            // Index 3: Profile Screen Navigator
            _buildOffstageNavigator(3, _buildProfileNavigator()), 
          ],
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return CustomBottomNavBar(
              currentIndex: _currentIndex,
              cartBadgeCount: cartProvider.itemCount, 
              onTap: (index) {
                if (index == _currentIndex) {
                  _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _currentIndex != index,
      child: child,
    );
  }

  Widget _buildHomeNavigator() {
    return Navigator(
      key: _navigatorKeys[0],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
            if (routeSettings.name == '/ProductDetails') {
              final product = routeSettings.arguments as ProductModel;
              return ProductDetailsScreen(product: product);
            } else if (routeSettings.name == '/Search') {
              return const SearchScreen(); 
            }
            return  HomeScreen();
          },
        );
      },
    );
  }

  // Profile Navigator
  Widget _buildProfileNavigator() {
    return Navigator(
      key: _navigatorKeys[3],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      },
    );
  }
}