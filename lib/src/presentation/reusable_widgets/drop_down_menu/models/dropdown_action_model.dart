import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DropDownAction extends Equatable {
  DropDownAction({
    required this.title,
    required this.onTap,
    this.icon,
    this.isSelected = false,
    this.iconSize,
  });

  final String title;
  final IconData? icon;
  final double? iconSize;
  bool isSelected;
  final Function(BuildContext) onTap;

  static DropDownAction from(DropDownAction action) {
    var newAction = DropDownAction(
        title: action.title,
        onTap: action.onTap,
        icon: action.icon,
        iconSize: action.iconSize);
    newAction.isSelected = action.isSelected;

    return newAction;
  }

  @override
  List<Object?> get props => [title, isSelected, icon];
}
