import 'package:flutter/cupertino.dart';
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
    required this.itemAnimation,
    required this.onTap,
  });

  final DropDownItem item;
  final DropDownMenuCubit cubit;
  final Animation<double> itemAnimation;
  final Future<void> Function(DropDownItem, Offset) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (item.onTap == null) {
          onTap(item, position);
        } else {
          item.onTap!();
        }
      },
      onTapDown: (details) {
        cubit.onItemTapResponse(item, true);
      },
      onTapUp: (details) {
        onTapEnd(item);
      },
      onTapCancel: () {
        onTapEnd(item);
      },
      child: SizeTransition(
        sizeFactor: itemAnimation,
        axis: Axis.vertical,
        axisAlignment: -1.0,
        child: Align(
          alignment: Alignment.topCenter,
          child: BlocBuilder<DropDownMenuCubit, DropDownMenuState>(
            bloc: cubit,
            buildWhen: (prev, current) {
              return needToReDraw(prev, current);
            },
            builder: (context, state) {
              FlutterLogs.logInfo(
                  'Presentation', 'dropdown', 'item: ${item.title}');
              return AnimatedContainer(
                decoration: BoxDecoration(
                  color: item.tapResponseColor ?? item.visualState.background,
                  borderRadius: _getBorderRadius(),
                  border: null,
                ),
                width: item.visualState.itemWidth,
                height: item.visualState.itemHeight,
                duration: const Duration(milliseconds: 250),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(
                        horizontal: item.visualState.horizontalPadding,
                      ),
                      child: Row(
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
                    ),
                    const Expanded(child: SizedBox()),
                    buildDivider()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void onTapEnd(DropDownItem item) {
    Future.delayed(
      const Duration(milliseconds: 100),
    ).whenComplete(() {
      cubit.onItemTapResponse(item, false);
    });
  }

  AnimatedContainer buildDivider() {
    return AnimatedContainer(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 250),
      height: item == cubit.state.items.last && !item.isActive ? 0.0 : 0.3,
      width: item.visualState.itemWidth,
      color: item.visualState.dividerColor,
    );
  }

  AnimatedRotation buildArrowWidget() {
    if (item.onTap == null) {
      return AnimatedRotation(
        turns: _getRotation(),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: item.visualState.scale,
          child: DropDownIconWidget(
            icon: CupertinoIcons.chevron_right,
            iconSize: 14,
            item: item,
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
        iconSize: item.iconSize ?? 16,
        item: item,
      ),
    );
  }

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
      return const BorderRadius.only(
          topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0));
    } else if (item == cubit.state.items.first) {
      return const BorderRadius.only(
          topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0));
    } else if (item == cubit.state.items.last) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      );
    }
    return const BorderRadius.all(Radius.zero);
  }

  double _getRotation() {
    return item.isActive ? 0.25 : 0;
  }
}
