import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_cubit.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/cubit/dropdown_menu_state.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_icon.dart';

class DropDownItemWidget extends StatelessWidget {
  const DropDownItemWidget({
    super.key,
    required this.item,
    required this.cubit,
  });

  final DropDownItem item;
  final DropDownMenuCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropDownMenuCubit, DropDownMenuState>(
      bloc: cubit,
      buildWhen: (prev, current) {
        return needToReDraw(prev, current);
      },
      builder: (context, state) {
        FlutterLogs.logInfo('Presentation', 'dropdown', 'item: ${item.title}');
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                color: item.tapResponseColor ?? item.visualState.background,
                borderRadius: _getBorderRadius(),
              ),
              width: item.visualState.itemWidth,
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: item.visualState.horizontalPadding,
                vertical: item.visualState.verticalPadding,
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
                        SizedBox(width: item.visualState.firstSpace),
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

  AnimatedContainer buildDividerWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: item.visualState.itemWidth,
      height: item == cubit.state.items.last || item.isActive ? 0 : 0.1,
      decoration: BoxDecoration(color: item.visualState.dividerColor),
    );
  }

  AnimatedRotation buildArrowWidget() {
    return AnimatedRotation(
      turns: _getRotation(),
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 250),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: item.visualState.scale,
        child: DropDownIconWidget(
          icon: Icons.arrow_forward_ios,
          iconSize: 12,
          item: item,
        ),
      ),
    );
  }

  /* Icon(
  Icons.arrow_forward_ios,
  size: 12,
  color: animation.value,
  ),*/
  SizedBox buildTextSpaceWidget() {
    return SizedBox(
      width: item.visualState.maxTextSpace,
      child: AnimatedDefaultTextStyle(
        curve: Curves.easeInOut,
        style: GoogleFonts.roboto(
          color: item.visualState.textColor,
          fontSize: item.visualState.textSize,
        ),
        duration: const Duration(milliseconds: 250),
        child: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  AnimatedScale buildIconWidget() {
    return AnimatedScale(
      curve: Curves.easeInOut,
      scale: item.visualState.scale,
      duration: const Duration(milliseconds: 250),
      child: DropDownIconWidget(
        icon: item.icon,
        iconSize: 16,
        item: item,
      ),
    );
  }

/*Icon(
        widget.item.icon,
        size: 16,
        color: animation.value,
      )*/
  bool needToReDraw(DropDownMenuState prev, DropDownMenuState current) {
    for (int i = 0; i < prev.items.length; i += 1) {
      var currentObj = current.items[i];
      if (currentObj.title == item.title) {
        bool res = currentObj != item;
        if (res) {
          item.tapResponseColor = currentObj.tapResponseColor;
        }
        return res;
      }
    }
    return true;
  }

  BorderRadius _getBorderRadius() {
    if (item.isActive) {
      return const BorderRadius.vertical(
        top: Radius.circular(10.0),
        bottom: Radius.zero,
      );
    } else if (item == cubit.state.items.last) {
      return const BorderRadius.vertical(bottom: Radius.circular(10.0));
    } else if (item == cubit.state.items.first) {
      return const BorderRadius.vertical(top: Radius.circular(10.0));
    }
    return const BorderRadius.all(Radius.zero);
  }

  double _getRotation() {
    return item.isActive ? 0.25 : 0;
  }
}
