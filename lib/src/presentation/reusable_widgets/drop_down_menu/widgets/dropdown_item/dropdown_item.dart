import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/cubit/dropdown_menu_state.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/visual_effects/item_states/active_item.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/widgets/dropdown_action/dropdown_action_list.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/widgets/dropdown_item/dropdown_icon.dart';

class DropDownItemWidget extends StatefulWidget {
  const DropDownItemWidget({
    super.key,
    required this.item,
    required this.cubit,
  });

  final DropDownItem item;
  final DropDownMenuCubit cubit;

  @override
  State<DropDownItemWidget> createState() => _DropDownItemWidgetState();
}

class _DropDownItemWidgetState extends State<DropDownItemWidget> {
  OverlayEntry? overlayEntry;
  Color? tapResponceColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (widget.item.onTap == null) {
          _onTap(widget.item, position);
        } else {
          widget.item.onTap!();
        }
      },
      onTapUp: (d) {
        Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
          tapResponceColor = null;
          setState(() {});
        });
      },
      onTapDown: (details) {
        tapResponceColor = AppColors.lightPressedGrey;
        setState(() {});
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
            return _needToReDraw(prev, current);
          },
          builder: (context, state) {
            return Material(
              elevation: widget.item.isActive ? 10.0 : 5.0,
              borderRadius: _getBorderRadius(),
              animationDuration: const Duration(milliseconds: 250),
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: tapResponceColor ?? widget.item.visualState.background,
                  borderRadius: _getBorderRadius(),
                  border: null,
                ),
                width: widget.item.visualState.itemWidth,
                height: widget.item.visualState.itemHeight,
                duration: const Duration(milliseconds: 250),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.item.visualState.horizontalPadding,
                      ),
                      child: Row(
                        children: [
                          _buildIconWidget(),
                          SizedBox(width: widget.item.visualState.firstSpace),
                          _buildTextSpaceWidget(),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          _buildArrowWidget()
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    _buildDivider()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry = null;

    super.dispose();
  }

  void _buildDropDownAction(DropDownActionListWidget actionsWidget) {
    overlayEntry = OverlayEntry(
      builder: (appContext) {
        return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 300)),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return actionsWidget;
            } else {
              return Container();
            }
          },
        );
      },
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  Future<void> _removeHighlightOverlay() async {
    overlayEntry?.remove();
    overlayEntry = null;
    widget.cubit.uncheckItem();
  }

  Future<void> _onTap(DropDownItem item, Offset position) async {
    if (item.isActive == false &&
        item.visualState == ActiveItemState.getInstance()) {
      widget.cubit.onItemClick(item);

      _buildDropDownAction(
        DropDownActionListWidget(
          item: item,
          cubit: widget.cubit,
          onClose: _removeHighlightOverlay,
          parentPosition: position,
        ),
      );
    }
  }

  AnimatedContainer _buildDivider() {
    return AnimatedContainer(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 250),
      height:
          widget.item == widget.cubit.state.items.last && !widget.item.isActive
              ? 0.0
              : 0.3,
      width: widget.item.visualState.itemWidth,
      color: widget.item.visualState.dividerColor,
    );
  }

  AnimatedRotation _buildArrowWidget() {
    if (widget.item.onTap == null) {
      return AnimatedRotation(
        turns: _getRotation(),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: widget.item.visualState.scale,
          child: DropDownIconWidget(
            icon: AppIcons.forwardChevron,
            iconSize: 14,
            item: widget.item,
          ),
        ),
      );
    } else {
      return const AnimatedRotation(
        turns: 1,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  SizedBox _buildTextSpaceWidget() {
    return SizedBox(
      width: widget.item.visualState.maxTextSpace,
      child: AnimatedDefaultTextStyle(
        curve: Curves.easeInOut,
        style: GoogleFonts.mPlusRounded1c(
          color: widget.item.visualState.textColor,
          fontSize: widget.item.visualState.textSize,
        ),
        duration: const Duration(milliseconds: 250),
        child: Text(
          widget.item.title,
          maxLines: 1,
          style: AppTextStyles.smallDropDownStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  AnimatedScale _buildIconWidget() {
    return AnimatedScale(
      curve: Curves.easeInOut,
      scale: widget.item.visualState.scale,
      duration: const Duration(milliseconds: 250),
      child: DropDownIconWidget(
        icon: widget.item.icon,
        iconSize: widget.item.iconSize ?? 16,
        item: widget.item,
      ),
    );
  }

  bool _needToReDraw(DropDownMenuState prev, DropDownMenuState current) {
    for (int i = 0; i < prev.items.length; i += 1) {
      var currentObj = current.items[i];
      if (currentObj.title == widget.item.title) {
        bool res = currentObj != widget.item;
        return res;
      }
    }
    return true;
  }

  BorderRadius _getBorderRadius() {
    if (widget.item.isActive) {
      return const BorderRadius.only(
        topRight: Radius.circular(10.0),
        topLeft: Radius.circular(10.0),
      );
    } else if (widget.item == widget.cubit.state.items.first) {
      return const BorderRadius.only(
        topRight: Radius.circular(10.0),
        topLeft: Radius.circular(10.0),
      );
    } else if (widget.item == widget.cubit.state.items.last) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      );
    }
    return const BorderRadius.all(Radius.zero);
  }

  double _getRotation() {
    return widget.item.isActive ? 0.25 : 0;
  }
}
