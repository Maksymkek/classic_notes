import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';

class ColorActionWidget extends StatefulWidget {
  const ColorActionWidget({
    super.key,
    required this.cubit,
    required this.pickerColor,
  });

  final NoteFormCubit cubit;
  final Color pickerColor;

  @override
  State<ColorActionWidget> createState() => _ColorActionWidgetState();
}

class _ColorActionWidgetState extends State<ColorActionWidget>
    with TickerProviderStateMixin {
  Color textColor = AppColors.black;
  late AnimationController scaleController;
  late Animation<double?> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.cubit.onMetadataButtonPressed(
          MetadataValue.color,
          color: widget.pickerColor,
        );
        scaleController.reverse().whenComplete(() => scaleController.forward());
      },
      onTapDown: (details) {
        scaleController.reverse();
      },
      onTapCancel: () {
        scaleController.forward();
      },
      child: SizedBox(
        width: 36,
        child: BlocListener<NoteFormCubit, NoteForm>(
          bloc: widget.cubit,
          listener: (context, state) {
            if (textColor != state.currentMetadata.metadata.color) {
              textColor = state.currentMetadata.metadata.color;
              setState(() {});
            }
          },
          child: ScaleTransition(
            scale: scaleController,
            child: AnimatedContainer(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
              duration: const Duration(milliseconds: 150),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 150),
    );
    scaleAnimation =
        CurvedAnimation(parent: scaleController, curve: Curves.fastOutSlowIn);
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }
}
