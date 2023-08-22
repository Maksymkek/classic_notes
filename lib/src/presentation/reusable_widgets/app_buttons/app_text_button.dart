import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';

class AppTextButtonWidget extends StatefulWidget {
  const AppTextButtonWidget({
    super.key,
    this.icon,
    required this.text,
    required this.onPressed,
    this.iconSize = 26.0,
    required this.color,
    this.activeColor = AppColors.green,
    this.textSize = 20.0,
    this.spacer = 5.0,
    this.textStyle,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final double iconSize;
  final TextStyle? textStyle;
  final Color color;
  final Color activeColor;
  final double textSize;
  final double spacer;

  @override
  State<AppTextButtonWidget> createState() => _AppTextButtonWidgetState();
}

class _AppTextButtonWidgetState extends State<AppTextButtonWidget>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> colorAnimation;
  late Animation<double> scaleAnimation;
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
      child: ScaleTransition(scale: scaleAnimation, child: _buildTextButton()),
    );
  }

  Widget _buildTextButton() {
    final text = Text(
      widget.text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: widget.textStyle?.copyWith(color: colorAnimation.value) ??
          GoogleFonts.nunito(
            fontSize: widget.textSize,
            color: colorAnimation.value,
            fontWeight: FontWeight.w600,
          ),
    );
    return widget.icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: widget.iconSize,
                color: colorAnimation.value,
              ),
              SizedBox(width: widget.spacer),
              text
            ],
          )
        : text;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
      reverseDuration: const Duration(milliseconds: 600),
    );
    colorAnimation = ColorTween(begin: widget.color, end: widget.activeColor)
        .animate(controller);
    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(controller);
    colorAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
