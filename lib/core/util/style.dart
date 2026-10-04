import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garrib_app/core/util/colors.dart';

class AppStyles {
  static TextStyle logo = GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    letterSpacing: -0.5,
  );

  static TextStyle heading1 = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    letterSpacing: -0.3,
  );

  static TextStyle heading2 = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static TextStyle buttonText = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );
}