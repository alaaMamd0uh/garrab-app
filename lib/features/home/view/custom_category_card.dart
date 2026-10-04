import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD9D9D9), 
            width: 1.3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            Image.asset(
              imagePath,
              width: 34,
              height: 34,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 7),
          
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.bodySmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700, // Medium
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}