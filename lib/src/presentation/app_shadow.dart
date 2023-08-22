import 'package:flutter/rendering.dart';
import 'package:notes/src/presentation/app_colors.dart';

abstract class AppShadow {
  static final BoxShadow baseShadow = BoxShadow(
    color: AppColors.black.withOpacity(0.23),
    spreadRadius: 0,
    blurRadius: 6,
    offset: const Offset(0, 0), // changes position of shadow
  );
}
