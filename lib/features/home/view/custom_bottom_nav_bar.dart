import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart'; 

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartBadgeCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84, 
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.65),
              border: Border(
                top: BorderSide(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  label: 'Home',
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  index: 0,
                ),

                _buildCartItem(
                  label: 'Cart',
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag,
                  index: 1,
                ),

                _buildNavItem(
                  label: 'Favorites',
                  icon: Icons.favorite_border,
                  selectedIcon: Icons.favorite,
                  index: 2,
                ),

                _buildNavItem(
                  label: 'Profile',
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  Nav item  
  Widget _buildNavItem({
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final activeColor = isSelected
        ? AppColors.black
        : const Color.fromARGB(110, 26, 26, 26);

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 26, 
              color: activeColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem({
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final activeColor = isSelected
        ? AppColors.black
        : const Color.fromARGB(110, 26, 26, 26);

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 26,
                  color: activeColor,
                ),
                if (cartBadgeCount > 0)
                  Positioned(
                    top: -3,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.terracotta,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartBadgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}