import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';

abstract class AppTextStyles {
  static final smallStyle = GoogleFonts.nunito(
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static final bigBoldStyle = GoogleFonts.varelaRound(
    color: AppColors.darkGrey,
    fontSize: 48,
    fontWeight: FontWeight.w600,
  );

  static final middleStyle =
      GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600);
  static final extraSmallStyle =
      GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600);
  static final middlePlusStyle =
      GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600);
  static final bigHeaderStyle = GoogleFonts.varelaRound(
    fontSize: 34,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w600,
  );
  static final smallHintStyle = GoogleFonts.nunito(
    color: AppColors.hintGrey,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static var smallDropDownStyle =
      GoogleFonts.nunito(fontWeight: FontWeight.w600);

  static final bigHintStyle = GoogleFonts.nunito(
    color: AppColors.hintGrey,
    fontSize: 20,
  );
}
