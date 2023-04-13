import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_state.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/visual_effects/item_states/disabled_item.dart';

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

class _DropDownItemWidgetState extends State<DropDownItemWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color?> animation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropDownMenuCubit, DropDownMenuState>(
      bloc: widget.cubit,
      buildWhen: (prev, current) {
        return needToReDraw(prev, current);
      },
      builder: (context, state) {
        FlutterLogs.logInfo(
            'Presentation', 'dropdown', 'item: ${widget.item.title}');
        checkLabelColor();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                color: widget.item.tapResponseColor ??
                    widget.item.visualState.background,
                borderRadius: _getBorderRadius(),
              ),
              width: widget.item.visualState.itemWidth,
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: widget.item.visualState.horizontalPadding,
                vertical: widget.item.visualState.verticalPadding,
              ),
              clipBehavior: Clip.antiAlias,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        buildIconWidget(),
                        SizedBox(width: widget.item.visualState.firstSpace),
                        buildTextSpaceWidget(),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        buildArrowWidget()
                      ],
                    ),
                  ],
                ),
              ),
            ),
            buildDividerWidget()
          ],
        );
      },
    );
  }

  void checkLabelColor() {
    if (widget.item.visualState == DisabledItemState.getInstance()) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
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

  AnimatedContainer buildDividerWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: widget.item.visualState.itemWidth,
      height:
          widget.item == widget.cubit.state.items.last || widget.item.isActive
              ? 0
              : 0.1,
      decoration: BoxDecoration(color: widget.item.visualState.dividerColor),
    );
  }

  AnimatedRotation buildArrowWidget() {
    return AnimatedRotation(
      turns: _getRotation(),
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 250),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: widget.item.visualState.scale,
        child: Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: animation.value,
        ),
      ),
    );
  }

  SizedBox buildTextSpaceWidget() {
    return SizedBox(
      width: widget.item.visualState.maxTextSpace,
      child: AnimatedDefaultTextStyle(
        curve: Curves.easeInOut,
        style: GoogleFonts.roboto(
          color: widget.item.visualState.textColor,
          fontSize: widget.item.visualState.textSize,
        ),
        duration: const Duration(milliseconds: 250),
        child: Text(
          widget.item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  AnimatedScale buildIconWidget() {
    return AnimatedScale(
      curve: Curves.easeInOut,
      scale: widget.item.visualState.scale,
      duration: const Duration(milliseconds: 250),
      child: Icon(
        widget.item.icon,
        size: 16,
        color: animation.value,
      ),
    );
  }

  bool needToReDraw(DropDownMenuState prev, DropDownMenuState current) {
    for (int i = 0; i < prev.items.length; i += 1) {
      var currentObj = current.items[i];
      if (currentObj.title == widget.item.title) {
        bool res = currentObj != widget.item;
        if (res) {
          widget.item.tapResponseColor = currentObj.tapResponseColor;
        }
        return res;
      }
    }
    return true;
  }

  BorderRadius _getBorderRadius() {
    if (widget.item.isActive) {
      return const BorderRadius.vertical(
        top: Radius.circular(10.0),
        bottom: Radius.zero,
      );
    } else if (widget.item == widget.cubit.state.items.last) {
      return const BorderRadius.vertical(bottom: Radius.circular(10.0));
    } else if (widget.item == widget.cubit.state.items.first) {
      return const BorderRadius.vertical(top: Radius.circular(10.0));
    }
    return const BorderRadius.all(Radius.zero);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  double _getRotation() {
    return widget.item.isActive ? 0.25 : 0;
  }
}
