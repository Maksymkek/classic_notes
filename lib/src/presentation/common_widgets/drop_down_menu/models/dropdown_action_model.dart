import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DropDownAction extends Equatable {
  DropDownAction({
    required this.title,
    required this.onTap,
    required this.icon,
    this.isSelected = false,
  });

  final String title;
  final IconData icon;
  bool isSelected;
  final Function() onTap;
  Color? tapResponseColor;

  static DropDownAction from(DropDownAction action) {
    var newAction = DropDownAction(
      title: action.title,
      onTap: action.onTap,
      icon: action.icon,
    );
    newAction.isSelected = action.isSelected;

    newAction.tapResponseColor = action.tapResponseColor;
    return newAction;
  }

  @override
  List<Object?> get props => [title, isSelected, icon, tapResponseColor];
}
