import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/folder_form_screen/models/icon_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';

class IconPickerWidget extends StatelessWidget {
  const IconPickerWidget({
    super.key,
    required this.model,
    required this.onPressed,
  });

  final IconPickerModel model;
  final Function(IconPickerModel) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.5, right: 7.5),
      child: GestureDetector(
        onTap: () => onPressed(model),
        behavior: HitTestBehavior.translucent,
        child: AnimatedContainer(
          duration: duration,
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: model.isActive ? [shadow] : null,
          ),
          child: Align(
              alignment: Alignment.center,
              child: Icon(model.icon, size: model.iconSize)),
        ),
      ),
    );
  }
}
