import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';

class AppStyles {
  static final smallTextStyle = GoogleFonts.alexandria(
    color: AppColors.darkBrown,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final bigBoldTextStyle = GoogleFonts.alexandria(
    color: AppColors.darkBrown,
    fontSize: 42,
    fontWeight: FontWeight.w300,
  );

  static final middleBolderTextStyle = GoogleFonts.galdeano(
    fontSize: 20,
    fontWeight: FontWeight.w300,
  );
}
