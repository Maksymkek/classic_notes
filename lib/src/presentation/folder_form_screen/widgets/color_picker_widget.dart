import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    super.key,
    required this.model,
    required this.onPressed,
  });

  final ColorPickerModel model;
  final Function(ColorPickerModel) onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(model),
      child: Padding(
        padding: const EdgeInsets.only(left: 7.5, right: 7.5),
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: model.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.23),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: AnimatedCrossFade(
              alignment: Alignment.center,
              firstChild: Icon(
                AppIcons.selected,
                size: 22,
                color: model.iconColor,
              ),
              secondChild: const SizedBox(),
              crossFadeState: model.isActive
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: duration,
            ),
          ),
        ),
      ),
    );
  }
}
