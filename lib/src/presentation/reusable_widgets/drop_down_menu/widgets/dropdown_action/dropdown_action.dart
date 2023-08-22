import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_state.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';

class DropDownActionWidget extends StatefulWidget {
  const DropDownActionWidget({
    super.key,
    required this.action,
    required this.cubit,
    required this.item,
    required this.onClose,
    required this.animation,
  });

  final DropDownAction action;
  final DropDownItem item;
  final DropDownMenuCubit cubit;
  final VoidCallback onClose;
  final Animation<double> animation;

  @override
  State<DropDownActionWidget> createState() => _DropDownActionWidgetState();
}

class _DropDownActionWidgetState extends State<DropDownActionWidget> {
  Color? tapResponceColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.animation.isCompleted || widget.animation.isDismissed) {
          widget.cubit.onActionSelected(widget.action, context);
          Future.delayed(const Duration(milliseconds: 250))
              .whenComplete(widget.onClose);
        }
      },
      onTapDown: (details) {
        tapResponceColor = AppColors.lightPressedGrey;
        setState(() {});
      },
      onTapUp: (details) {
        Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
          tapResponceColor = null;
          if (mounted) setState(() {});
        });
      },
      onTapCancel: () {
        Future.delayed(const Duration(milliseconds: 150)).whenComplete(() {
          tapResponceColor = null;
          setState(() {});
        });
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: BlocBuilder<DropDownMenuCubit, DropDownMenuState>(
          bloc: widget.cubit,
          buildWhen: (prev, current) {
            return _needToRedraw(prev, current, widget.action);
          },
          builder: (context, snapshot) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 200,
              height: 28,
              clipBehavior: Clip.antiAlias,
              //padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: tapResponceColor ?? AppColors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                    child: SizedBox(
                      width: 16,
                      child: Icon(
                        widget.action.icon,
                        size: widget.action.iconSize ?? 16,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  _buildTextWidget(),
                  const Spacer(),
                  _buildSelectionIconWidget()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AnimatedCrossFade _buildSelectionIconWidget() {
    return AnimatedCrossFade(
      firstChild: const Row(
        children: [
          Icon(
            AppIcons.selected,
            size: 14,
            color: AppColors.darkGrey,
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      crossFadeState: widget.action.isSelected
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      secondChild: Container(),
      duration: const Duration(milliseconds: 150),
    );
  }

  SizedBox _buildTextWidget() {
    return SizedBox(
      width: 130,
      child: Text(
        widget.action.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.smallDropDownStyle,
      ),
    );
  }

  bool _needToRedraw(
    DropDownMenuState prev,
    DropDownMenuState current,
    DropDownAction action,
  ) {
    DropDownItem currentObj = _getCurrentItem(current);
    for (int i = 0; i < currentObj.actions.length; i += 1) {
      var curAction = currentObj.actions[i];
      if (curAction.title == action.title) {
        bool res = curAction != action;
        if (res) {
          action.isSelected = curAction.isSelected;
        }
        return res;
      }
    }
    return true;
  }

  DropDownItem _getCurrentItem(DropDownMenuState current) {
    var index = current.items.indexOf(widget.item);
    if (index == -1) {
      for (int i = 0; i < current.items.length; i += 1) {
        if (current.items[i].title == widget.item.title) {
          index = i;
        }
      }
    }
    var currentObj = current.items[index];
    return currentObj;
  }
}
