import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/visual_effects/item_states/active_item.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_action_list.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_item.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/widget_offset_key.dart';

class DropDownItemListWidget extends StatefulWidget {
  const DropDownItemListWidget({
    required super.key,
    required this.onClose,
    required this.overlayState,
    required this.itemAnimation,
    required this.dropDownItems,
  });

  final VoidCallback onClose;
  final OverlayState overlayState;
  final Animation<double> itemAnimation;
  final List<DropDownItem> dropDownItems;

  @override
  State<DropDownItemListWidget> createState() => _DropDownItemListWidgetState();
}

class _DropDownItemListWidgetState extends State<DropDownItemListWidget>
    with SingleTickerProviderStateMixin {
  late final DropDownMenuCubit cubit;
  OverlayEntry? overlayEntry;
  AnimationController? animationController;
  Animation<double>? actionAnimation;
  late BorderRadius borderRadius;
  bool canClose = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: FadeTransition(
        opacity: widget.itemAnimation,
        child: Scaffold(
          backgroundColor: AppColors.black.withOpacity(0.04),
          body: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: _getOffset(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                clipBehavior: Clip.antiAlias,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: cubit.state.items
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            _onTap(item);
                          },
                          onTapDown: (details) {
                            cubit.onItemTapResponse(item, true);
                          },
                          onTapUp: (details) {
                            _onTapEnd(item);
                          },
                          onTapCancel: () {
                            _onTapEnd(item);
                          },
                          child: SizeTransition(
                            sizeFactor: widget.itemAnimation,
                            axis: Axis.vertical,
                            axisAlignment: -1.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: DropDownItemWidget(
                                item: item,
                                cubit: cubit,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
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
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    actionAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController!,
    );
    cubit = DropDownMenuCubit(
      widget.dropDownItems,
      (widget.key as GlobalKey?)?.globalPaintBounds?.bottom ?? 120,
    );
    borderRadius = const BorderRadius.all(Radius.circular(10.0));
    cubit.uncheckItem();
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry = null;
    animationController?.dispose();
    super.dispose();
  }

  void onClose() {
    if (canClose) {
      cubit.syncChangedSettings(widget.dropDownItems);
      widget.onClose();
    }
  }

  EdgeInsets _getOffset() {
    return EdgeInsets.fromLTRB(0.0, cubit.state.dy, 19.6, 0.0);
  }

  void _buildDropDownAction(DropDownActionListWidget actionsWidget) {
    canClose = false;
    overlayEntry = OverlayEntry(
      builder: (appContext) {
        return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 300)),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              animationController?.forward().whenComplete(
                    () => {canClose = true},
                  );
              return actionsWidget;
            } else {
              return Container();
            }
          },
        );
      },
    );
    widget.overlayState.insert(overlayEntry!);
  }

  Future<void> _removeHighlightOverlay() async {
    canClose = false;
    await animationController?.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
    cubit.uncheckItem();
    _setRoundedCorners();
    canClose = true;
  }

  void _setRectangleBorders() {
    if (borderRadius !=
        const BorderRadius.vertical(top: Radius.circular(10.0))) {
      borderRadius = const BorderRadius.vertical(top: Radius.circular(10.0));
      setState(() {});
    }
  }

  void _setRoundedCorners() {
    if (borderRadius != const BorderRadius.all(Radius.circular(10.0))) {
      borderRadius = const BorderRadius.all(Radius.circular(10.0));
      setState(() {});
    }
  }

  Future<void> _onTap(DropDownItem item) async {
    await Future.delayed(
      const Duration(milliseconds: 150),
    );
    if (item.isActive == false &&
        item.visualState == ActiveItemState.getInstance() &&
        canClose == true) {
      cubit.onItemClick(item);
      canClose = true;
      if (item == cubit.state.items.last) {
        _setRectangleBorders();
      }
      _buildDropDownAction(
        DropDownActionListWidget(
          item: item,
          cubit: cubit,
          onClose: _removeHighlightOverlay,
          animation: actionAnimation!,
        ),
      );
    }
  }

  void _onTapEnd(DropDownItem item) {
    Future.delayed(
      const Duration(milliseconds: 100),
    ).whenComplete(() {
      cubit.onItemTapResponse(item, false);
    });
  }
}
