import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';

class SlidableActionWidget extends StatefulWidget {
  const SlidableActionWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<SlidableActionWidget> createState() => _SlidableActionWidgetState();
}

class _SlidableActionWidgetState extends State<SlidableActionWidget>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
      reverseDuration: const Duration(seconds: 1),
    );
    animation = ColorTween(end: widget.color, begin: AppColors.darkBrown)
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OverflowBox(
            alignment: Alignment.topRight,
            maxWidth: constraints.maxWidth,
            child: GestureDetector(
              onTap: () {
                controller.forward().whenComplete(() => controller.reverse());
                widget.onTap();
              },
              onTapDown: (details) {
                controller.forward();
              },
              onTapCancel: () {
                controller.reverse();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    widget.icon,
                    size: 32,
                    color: animation.value,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
