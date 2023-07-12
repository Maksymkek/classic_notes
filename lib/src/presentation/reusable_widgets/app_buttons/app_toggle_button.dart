import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/app_colors.dart';

class AppToggleButtonWidget extends StatefulWidget {
  const AppToggleButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 26.0,
    required this.color,
    this.activeColor = AppColors.green,
    required this.cubit,
    required this.isToggled,
    this.startToggled = false,
  });

  final void Function() onPressed;
  final IconData icon;
  final double iconSize;
  final Color color;
  final Cubit cubit;
  final bool startToggled;
  final Color activeColor;
  final bool Function() isToggled;

  @override
  State<AppToggleButtonWidget> createState() => _AppToggleButtonWidgetState();
}

class _AppToggleButtonWidgetState extends State<AppToggleButtonWidget>
    with TickerProviderStateMixin {
  late Animation<Color?> colorAnimation;
  late Animation<double?> scaleAnimation;
  late AnimationController colorController;
  late AnimationController scaleController;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: widget.cubit,
      listener: (context, state) {
        if (widget.isToggled()) {
          if (colorAnimation.isDismissed) {
            colorController.forward();
          }
        } else {
          if (colorAnimation.isCompleted) {
            colorController.reverse();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          widget.onPressed();

          scaleController
              .reverse()
              .whenComplete(() => scaleController.forward());
        },
        onTapDown: (details) {
          scaleController.reverse();
        },
        onTapCancel: () {
          scaleController.forward();
        },
        child: ScaleTransition(
          scale: scaleController,
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: colorAnimation.value,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    colorController = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
      reverseDuration: const Duration(milliseconds: 100),
    );
    colorAnimation = ColorTween(begin: widget.color, end: widget.activeColor)
        .animate(colorController);
    scaleController = AnimationController(
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 100),
    );
    scaleAnimation =
        CurvedAnimation(parent: scaleController, curve: Curves.fastOutSlowIn);
    colorAnimation.addListener(() {
      setState(() {});
    });
    scaleController.forward();
    if (widget.startToggled) {
      colorController.forward();
    }
  }

  @override
  void dispose() {
    colorController.dispose();
    scaleController.dispose();
    super.dispose();
  }
}
