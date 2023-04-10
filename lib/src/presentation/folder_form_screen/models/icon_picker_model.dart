import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/app_colors.dart';

class IconPickerModel {
  IconPickerModel({
    this.isActive = false,
    required this.icon,
    required this.iconSize,
    required this.trueIconSize,
    this.color = AppColors.darkBrown,
  });

  bool isActive;
  Color color;
  final IconData icon;
  final double iconSize;
  final double trueIconSize;
}
