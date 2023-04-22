import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/visual_effects/item_states/active_item.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/visual_effects/item_states/disabled_item.dart';

class DropDownIconWidget extends StatefulWidget {
  const DropDownIconWidget({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.item,
  });

  final IconData icon;
  final double iconSize;
  final DropDownItem item;

  @override
  State<DropDownIconWidget> createState() => _DropDownIconWidgetState();
}

class _DropDownIconWidgetState extends State<DropDownIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color?> animation;

  @override
  Widget build(BuildContext context) {
    checkColor();

    return Icon(
      widget.icon,
      size: widget.iconSize,
      color: animation.value,
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    animation = ColorTween(begin: AppColors.darkBrown, end: AppColors.white)
        .animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void checkColor() {
    if (widget.item.visualState == DisabledItemState.getInstance() &&
        animation.status == AnimationStatus.dismissed) {
      FlutterLogs.logWarn('Presentation', 'dropdown_icon',
          'forward${animation.status} item ${widget.item.title}');
      animationController.forward();
    } else if (widget.item.visualState == ActiveItemState.getInstance() &&
        animation.status == AnimationStatus.completed) {
      FlutterLogs.logWarn(
        'Presentation',
        'dropdown_icon',
        'reverse ${animation.status} item ${widget.item.title}',
      );
      animationController.reverse();
    }
  }
}
