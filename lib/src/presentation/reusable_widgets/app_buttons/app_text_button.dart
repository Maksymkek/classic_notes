import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';

class AppTextButtonWidget extends StatefulWidget {
  const AppTextButtonWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconSize = 26.0,
    required this.color,
    this.activeColor = AppColors.green,
    this.textSize = 20.0,
    this.spacer = 5.0,
  });
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final double iconSize;
  final Color color;
  final Color activeColor;
  final double textSize;
  final double spacer;

  @override
  State<AppTextButtonWidget> createState() => _AppTextButtonWidgetState();
}

class _AppTextButtonWidgetState extends State<AppTextButtonWidget>
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
      onTapDown: (details) {
        controller.forward();
      },
      onTapCancel: () {
        controller.reverse();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: widget.iconSize,
            color: animation.value,
          ),
          SizedBox(width: widget.spacer),
          Text(
            widget.text,
            style: TextStyle(fontSize: widget.textSize, color: animation.value),
          )
        ],
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
    animation = ColorTween(begin: widget.color, end: widget.activeColor)
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
