import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/app_colors.dart';

class IconPickerModel extends Equatable {
  IconPickerModel({
    this.isActive = false,
    required this.icon,
    required this.iconSize,
    required this.trueIconSize,
    this.color = AppColors.darkGrey,
  });

  bool isActive;
  Color color;
  final IconData icon;
  final double iconSize;
  final double trueIconSize;

  static IconPickerModel from(IconPickerModel iconPickerModel) {
    var newIconPickerModel = IconPickerModel(
      icon: iconPickerModel.icon,
      iconSize: iconPickerModel.iconSize,
      trueIconSize: iconPickerModel.trueIconSize,
      isActive: iconPickerModel.isActive,
    );
    newIconPickerModel.color = iconPickerModel.color;
    return newIconPickerModel;
  }

  @override
  List<Object?> get props => [isActive, icon, iconSize, trueIconSize, color];
}
