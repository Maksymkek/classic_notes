import 'package:flutter/material.dart';

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
  late Animation<double> animation;
  late AnimationController controller;

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
                controller.reverse().whenComplete(() => controller.forward());
                widget.onTap();
              },
              onTapDown: (details) {
                controller.reverse();
              },
              onTapCancel: () {
                controller.forward();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: animation,
                    child: Icon(
                      widget.icon,
                      size: 32,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.3,
      upperBound: 1.0,
      reverseDuration: const Duration(milliseconds: 0),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    controller.forward();
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
