import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/settings/change_theme.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';

final dropDownWidgetKey = GlobalKey();

//must have a global key or dy position of menu will be 80
class DropDownButtonWidget extends StatefulWidget {
  const DropDownButtonWidget({super.key, required this.dropdownItems});

  final List<DropDownItem> dropdownItems;

  @override
  State<DropDownButtonWidget> createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController menuAnimationController;
  late Animation<double> menuAnimation;
  late AnimationController buttonAnimationController;
  late Animation<Color?> buttonAnimation;
  late List<DropDownItem> appSettingsItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 6.0),
      child: GestureDetector(
        onTap: () {
          DropDownOverlayManager.buildOverlay(
            context: context,
            animation: menuAnimation,
            animationController: menuAnimationController,
            otherController: buttonAnimationController,
            dropDownItems: widget.dropdownItems,
          );
        },
        onTapDown: (d) {
          buttonAnimationController.forward();
        },
        onTapCancel: () {
          buttonAnimationController.reverse();
        },
        child: Icon(
          Icons.more_horiz,
          key: dropDownWidgetKey,
          //highlightColor: Colors.transparent,
          color: buttonAnimation.value ?? AppColors.darkBrown,

          size: 36,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var appSettings = DI.getInstance().appSettingsRepository.getSettings();
    menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    menuAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: menuAnimationController,
    );
    buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      reverseDuration: const Duration(milliseconds: 350),
    );
    buttonAnimation =
        ColorTween(begin: AppColors.darkBrown, end: AppColors.lightBrown)
            .animate(buttonAnimationController);
    buttonAnimation.addListener(() {
      setState(() {});
    });
    appSettingsItems = [
      DropDownItem(
        title: 'Change theme',
        icon: Icons.brightness_4,
        actions: [
          DropDownAction(
            title: ChangeTheme.light.name,
            onTap: () => DI
                .getInstance()
                .appSettingsRepository
                .setTheme(ChangeTheme.light.name),
            isSelected: appSettings.theme == ChangeTheme.light.name,
            icon: Icons.light_mode_rounded,
          ),
          DropDownAction(
            title: ChangeTheme.dark.name,
            onTap: () => DI
                .getInstance()
                .appSettingsRepository
                .setTheme(ChangeTheme.dark.name),
            isSelected: appSettings.theme == ChangeTheme.dark.name,
            icon: Icons.dark_mode_rounded,
          ),
          DropDownAction(
            title: ChangeTheme.auto.name,
            onTap: () => DI
                .getInstance()
                .appSettingsRepository
                .setTheme(ChangeTheme.auto.name),
            isSelected: appSettings.theme == ChangeTheme.auto.name,
            icon: Icons.auto_awesome_outlined,
          ),
        ],
      )
    ];
    widget.dropdownItems.addAll(appSettingsItems);
  }

  @override
  void dispose() {
    buttonAnimationController.dispose();
    menuAnimationController.dispose();
    super.dispose();
  }
}
