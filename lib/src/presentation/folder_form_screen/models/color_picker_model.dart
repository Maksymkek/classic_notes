import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

class ColorPickerModel extends Equatable {
  ColorPickerModel({
    required this.color,
    required this.iconColor,
    this.isActive = false,
  });

  bool isActive;
  final Color color;
  final Color iconColor;

  static ColorPickerModel from(ColorPickerModel colorPickerModel) {
    var newColorPickerModel = ColorPickerModel(
      color: colorPickerModel.color,
      iconColor: colorPickerModel.iconColor,
      isActive: colorPickerModel.isActive,
    );
    return newColorPickerModel;
  }

  @override
  List<Object?> get props => [isActive, color, iconColor];
}
