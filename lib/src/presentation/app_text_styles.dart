import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';

abstract class AppTextStyles {
  static final smallStyle = GoogleFonts.alexandria(
    color: AppColors.darkBrown,
    fontSize: 16,
  );

  static final bigBoldStyle = GoogleFonts.alexandria(
    color: AppColors.darkBrown,
    fontSize: 44,
    fontWeight: FontWeight.w500,
  );

  static const middleStyle = TextStyle(
    fontFamily: 'Helvetica',
    fontSize: 18,
  );

  static const middlePlusStyle = TextStyle(
    fontFamily: 'Helvetica',
    fontSize: 20,
  );

  static final smallHintStyle = GoogleFonts.alexandria(
    color: AppColors.hintGrey,
    fontSize: 14,
  );

  static final smallDropDownStyle = GoogleFonts.roboto(
    color: AppColors.darkBrown,
  );

  static const bigHintStyle =
      TextStyle(color: AppColors.hintGrey, fontSize: 26);
}
