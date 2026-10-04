import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final double borderRadius;
  final String? svgPath;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 310,
    this.height = 55,
    this.backgroundColor = AppColors.black,
    this.textColor = Colors.white,
    this.elevation = 3,
    this.borderRadius = 12,
    this.svgPath, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: elevation,
          shadowColor: AppColors.black.withOpacity(0.3),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            if (svgPath != null) ...[
              SvgPicture.asset(
                svgPath!,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: AppStyles.buttonText.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}