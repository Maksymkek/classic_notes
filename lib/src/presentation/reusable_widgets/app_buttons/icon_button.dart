import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';

class AppIconButtonWidget extends StatefulWidget {
  const AppIconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 26.0,
    required this.color,
    this.activeColor = AppColors.green,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final double iconSize;
  final Color color;
  final Color activeColor;

  @override
  State<AppIconButtonWidget> createState() => _AppIconButtonWidgetState();
}

class _AppIconButtonWidgetState extends State<AppIconButtonWidget>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> animation;
  late final AnimationController controller;

  late final Animation<double> scaleAnimation;

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
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: animation.value,
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
    animation = ColorTween(begin: widget.color, end: widget.activeColor)
        .animate(controller);
    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(controller);
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
