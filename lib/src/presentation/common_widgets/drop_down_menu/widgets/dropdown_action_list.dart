import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_state.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_action.dart';

class DropDownActionListWidget extends StatelessWidget {
  const DropDownActionListWidget({
    super.key,
    required this.item,
    required this.cubit,
    required this.onClose,
    required this.animation,
  });

  final VoidCallback onClose;
  final DropDownItem item;
  final DropDownMenuCubit cubit;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (animation.isCompleted) {
          onClose();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: _getPadding(),
          child: Align(
            alignment: Alignment.topRight,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10.0),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                width: 200,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.lightBrown,
                      width: 0.2,
                    ),
                  ),
                ),
                child: buildActionWidgets(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildActionWidgets() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: item.actions
          .map(
            (action) => GestureDetector(
              onTap: () async {
                await Future.delayed(
                  const Duration(milliseconds: 150),
                );
                if (animation.isCompleted || animation.isDismissed) {
                  cubit.onActionSelected(action);
                  Future.delayed(
                    const Duration(milliseconds: 250),
                  ).whenComplete(() => onClose());
                }
              },
              onTapDown: (details) {
                cubit.onActionTapResponse(item, action, true);
              },
              onTapUp: (details) {
                _onTapEnd(action);
              },
              onTapCancel: () {
                _onTapEnd(action);
              },
              child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.vertical,
                axisAlignment: -1.0,
                child: BlocBuilder<DropDownMenuCubit, DropDownMenuState>(
                  bloc: cubit,
                  buildWhen: (prev, current) {
                    return needToRedraw(prev, current, action);
                  },
                  builder: (context, snapshot) {
                    return DropDownActionWidget(action: action);
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  bool needToRedraw(
    DropDownMenuState prev,
    DropDownMenuState current,
    DropDownAction action,
  ) {
    DropDownItem currentObj = getCurrentItem(current);
    for (int i = 0; i < currentObj.actions.length; i += 1) {
      var curAction = currentObj.actions[i];
      if (curAction.title == action.title) {
        bool res = curAction != action;
        if (res) {
          action.tapResponseColor = curAction.tapResponseColor;
          action.isSelected = curAction.isSelected;
        }
        return res;
      }
    }
    return true;
  }

  DropDownItem getCurrentItem(DropDownMenuState current) {
    var index = current.items.indexOf(item);
    if (index == -1) {
      for (int i = 0; i < current.items.length; i += 1) {
        if (current.items[i].title == item.title) {
          index = i;
        }
      }
    }
    var currentObj = current.items[index];
    return currentObj;
  }

  EdgeInsets _getPadding() {
    var top = cubit.state.dy;
    int itemId = cubit.getItemId(item);
    int i = 0;
    while (i <= itemId - 1) {
      top += 21.75;
      i += 1;
    }
    return EdgeInsets.fromLTRB(0.0, top + 29.8, 19.6, 0.0);
  }

  void _onTapEnd(DropDownAction action) {
    Future.delayed(
      const Duration(milliseconds: 100),
    ).whenComplete(
      () => cubit.onActionTapResponse(item, action, false),
    );
  }
}
