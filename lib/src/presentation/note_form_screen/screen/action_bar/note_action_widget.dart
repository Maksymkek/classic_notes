import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';

class NoteActionWidget extends StatefulWidget {
  const NoteActionWidget({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.width = 36,
    this.borderRadius,
  });

  final IconData icon;
  final double iconSize;
  final double width;
  final BorderRadius? borderRadius;
  final Function() onPressed;

  @override
  State<NoteActionWidget> createState() => _NoteActionWidgetState();
}

class _NoteActionWidgetState extends State<NoteActionWidget>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
        controller.forward().whenComplete(() => controller.reverse());
      },
      onTapDown: (d) {
        controller.forward();
      },
      onTapCancel: () {
        controller.reverse();
      },
      child: Container(
        width: widget.width,
        height: 30,
        decoration: BoxDecoration(
          color: animation.value,
          borderRadius: widget.borderRadius,
        ),
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: AppColors.darkBrown,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
      reverseDuration: const Duration(milliseconds: 600),
    );
    animation =
        ColorTween(begin: AppColors.light, end: AppColors.lightPressedGrey)
            .animate(controller);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
