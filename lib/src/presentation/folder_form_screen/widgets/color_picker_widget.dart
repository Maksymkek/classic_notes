import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({
    super.key,
    required this.model,
    required this.onPressed,
  });

  final ColorPickerModel model;
  final Function(ColorPickerModel) onPressed;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    checkIfActive();
    return GestureDetector(
      onTap: () => widget.onPressed(widget.model),
      child: Padding(
        padding: const EdgeInsets.only(left: 7.5, right: 7.5),
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: widget.model.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.23),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: animation,
              child: Icon(
                AppIcons.selected,
                size: 22,
                color: widget.model.iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);
    checkIfActive();
  }

  void checkIfActive() {
    if (widget.model.isActive) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
}
