import 'package:flutter/animation.dart';

class ColorPickerModel {
  ColorPickerModel({
    required this.color,
    required this.iconColor,
    this.isActive = false,
  });

  bool isActive;
  final Color color;
  final Color iconColor;
}
