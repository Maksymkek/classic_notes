import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';

final dropDownWidgetKey = GlobalKey();

//TODO need to refactor actions wait to open(wait animation)
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
  late Future<void> setAppSettingsFuture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 6.0),
      child: FutureBuilder(
        future: setAppSettingsFuture,
        builder: (context, snapshot) {
          if (ConnectionState.done == snapshot.connectionState) {
            return GestureDetector(
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
                color: buttonAnimation.value ?? AppColors.darkBrown,
                size: 36,
              ),
            );
          } else {
            return Icon(
              Icons.more_horiz,
              color: buttonAnimation.value ?? AppColors.darkBrown,
              size: 36,
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setAppSettingsFuture =
        DI.getInstance().appSettingsRepository.getSettings().whenComplete(() {
      _setItems();
    });
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
  }

//TODO: language choose
  void _setItems() {
    final settings = DI.getInstance().appSettingsRepository.settings;
    appSettingsItems = [
      DropDownItem(
        title: 'Change theme',
        icon: Icons.light_mode_outlined,
        actions: [
          DropDownAction(
            title: AppTheme.light.name,
            onTap: () =>
                DI.getInstance().appSettingsRepository.setTheme(AppTheme.light),
            isSelected: settings.theme == AppTheme.light.name,
            icon: Icons.light_mode_rounded,
          ),
          DropDownAction(
            title: AppTheme.dark.name,
            onTap: () =>
                DI.getInstance().appSettingsRepository.setTheme(AppTheme.dark),
            isSelected: settings.theme == AppTheme.dark.name,
            icon: Icons.dark_mode_rounded,
          ),
          DropDownAction(
            title: AppTheme.auto.name,
            onTap: () =>
                DI.getInstance().appSettingsRepository.setTheme(AppTheme.auto),
            isSelected: settings.theme == AppTheme.auto.name,
            icon: Icons.auto_awesome_outlined,
          ),
        ],
      ),
      DropDownItem(
        title: 'Language',
        icon: Icons.language,
        actions: [
          DropDownAction(
            title: AppLanguages.english.name,
            onTap: () => DI
                .getInstance()
                .appSettingsRepository
                .setLanguage(AppLanguages.english),
            isSelected: settings.language == AppLanguages.english.name,
            icon: Icons.notes_rounded,
          ),
          DropDownAction(
            title: AppLanguages.ukrainian.name,
            onTap: () => DI
                .getInstance()
                .appSettingsRepository
                .setLanguage(AppLanguages.ukrainian),
            isSelected: settings.language == AppLanguages.ukrainian.name,
            icon: Icons.notes_rounded,
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
