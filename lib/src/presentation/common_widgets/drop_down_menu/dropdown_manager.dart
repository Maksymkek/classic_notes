import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';

//Done only ui part
//TODO interference with the application data

final dropDownWidgetKey = GlobalKey();

class DropDownButtonWidget extends StatefulWidget {
  const DropDownButtonWidget({super.key, required this.dropdownItems});
  final List<DropDownItem> dropdownItems;

  @override
  State<DropDownButtonWidget> createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: dropDownWidgetKey,
      icon: const Icon(
        Icons.more_horiz,
        color: AppColors.darkBrown,
      ),
      onPressed: () {
        DropDownOverlayManager.buildFolderForm(
          context: context,
          animation: animation,
          animationController: animationController,
        );
      },
      iconSize: 36,
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
    animation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
