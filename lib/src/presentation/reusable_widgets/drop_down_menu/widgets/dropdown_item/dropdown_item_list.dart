import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/widgets/dropdown_item/dropdown_item.dart';

class DropDownItemListWidget extends StatefulWidget {
  const DropDownItemListWidget({
    super.key,
    required this.onClose,
    required this.overlayState,
    required this.dropDownItems,
    required this.parentPosition,
  });

  final VoidCallback onClose;
  final OverlayState overlayState;

  final List<DropDownItem> dropDownItems;
  final Offset parentPosition;

  @override
  State<DropDownItemListWidget> createState() => _DropDownItemListWidgetState();
}

class _DropDownItemListWidgetState extends State<DropDownItemListWidget>
    with TickerProviderStateMixin {
  late final DropDownMenuCubit cubit;
  late final AnimationController menuController;
  late final Animation<double> menuAnimation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClose,
      child: FadeTransition(
        opacity: menuAnimation,
        child: Scaffold(
          backgroundColor: AppColors.black.withOpacity(0.04),
          body: Padding(
            padding: _getOffset(),
            child: ScaleTransition(
              scale: menuAnimation,
              alignment: Alignment.topRight,
              child: Row(
                children: [
                  const Spacer(),
                  Column(
                    children: cubit.state.items
                        .map(
                          (item) => DropDownItemWidget(
                            item: item,
                            cubit: cubit,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    cubit = DropDownMenuCubit(
      widget.dropDownItems,
      widget.overlayState,
      widget.parentPosition.dy,
    );
    menuController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    menuAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: menuController,
    );
    menuController.forward();
    cubit.uncheckItem();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  void _onClose() {
    cubit.syncChangedSettings(widget.dropDownItems);
    menuController.reverse().whenComplete(() => widget.onClose());
  }

  EdgeInsets _getOffset() {
    return EdgeInsets.fromLTRB(0.0, cubit.state.dy, 19.6, 0.0);
  }
}
