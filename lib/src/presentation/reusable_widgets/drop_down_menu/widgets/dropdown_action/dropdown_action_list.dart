import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/active_item.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/disabled_item.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/widgets/dropdown_action/dropdown_action.dart';

class DropDownActionListWidget extends StatefulWidget {
  const DropDownActionListWidget({
    super.key,
    required this.item,
    required this.cubit,
    required this.onClose,
    required this.parentPosition,
  });

  final VoidCallback onClose;
  final DropDownItem item;
  final DropDownMenuCubit cubit;

  final Offset parentPosition;

  @override
  State<DropDownActionListWidget> createState() =>
      _DropDownActionListWidgetState();
}

class _DropDownActionListWidgetState extends State<DropDownActionListWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  late double elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClose,
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: Padding(
          padding: _getPadding(),
          child: _buildActionWidgets(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    animation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: controller,
    );

    elevation = 0;
    animation.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          elevation = 10;
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          elevation = 0;
        });
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onClose() {
    if (mounted) controller.reverse().whenComplete(() => widget.onClose());
  }

  Widget _buildActionWidgets() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        SizeTransition(
          sizeFactor: animation,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: Padding(
            padding: _getActionsListPadding(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Material(
                elevation: elevation,
                animationDuration: const Duration(milliseconds: 250),
                color: AppColors.transparent,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10.0)),
                clipBehavior: Clip.antiAlias,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0.0),
                  children: widget.item.actions
                      .map(
                        (action) => DropDownActionWidget(
                          action: action,
                          cubit: widget.cubit,
                          item: widget.item,
                          onClose: _onClose,
                          animation: animation,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  EdgeInsets _getActionsListPadding() {
    return const EdgeInsets.only(left: 20, bottom: 30, right: 19.6);
  }

  EdgeInsets _getPadding() {
    var top = widget.cubit.state.dy;
    int itemId = widget.cubit.getItemId(widget.item);
    int i = 0;
    while (i <= itemId - 1) {
      top += DisabledItemState.getInstance().itemHeight;
      i += 1;
    }
    return EdgeInsets.only(
      top: top + ActiveItemState.getInstance().itemHeight + 10,
    );
  }
}
