import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/folder_form_screen/models/color_picker_model.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/color_picker_widget.dart';

class NoteColorPickerWidget extends StatefulWidget {
  const NoteColorPickerWidget({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final Function(Color) onPressed;

  @override
  State<NoteColorPickerWidget> createState() => _NoteColorPickerWidgetState();
}

class _NoteColorPickerWidgetState extends State<NoteColorPickerWidget> {
  final List<ColorPickerModel> _colorPickers = [
    ColorPickerModel(
      color: AppColors.darkBrown,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.sapphireBlue,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.khaki,
      iconColor: AppColors.darkBrown,
    ),
    ColorPickerModel(
      color: AppColors.darkGreen,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.darkPurple,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.black,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.lightToggledGrey,
      iconColor: AppColors.seashellWhite,
    ),
    ColorPickerModel(
      color: AppColors.carmineRed,
      iconColor: AppColors.seashellWhite,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        top: widget.enabled ? 3.0 : 11.0,
        bottom: widget.enabled ? 3 : 0,
      ),
      duration: const Duration(milliseconds: 250),
      child: AnimatedContainer(
        width: double.infinity,
        height: !widget.enabled ? 0.0 : 42.0,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 250),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: _colorPickers
              .map(
                (picker) => TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  tween: Tween<double>(
                    begin: 0.0,
                    end: widget.enabled ? 28.0 : 0.0,
                  ),
                  builder: (context, size, child) {
                    return ColorPickerWidget(
                      model: picker,
                      onPressed: (selectedPicker) {
                        setState(() {});
                        widget.onPressed(selectedPicker.color);
                      },
                      size: size,
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
