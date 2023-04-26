import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_cubit.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';

//final dropDownWidgetKey = GlobalKey();

//TODO need to replace dropDownKey
// must have a global key or dy position of menu will be 120
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
  late AppSettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 6.0),
      child: BlocBuilder<AppSettingsCubit, AppSettings>(
        bloc: DI.getInstance().appSettingsCubit,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              rewriteItems();
              DropDownOverlayManager.buildOverlay(
                context: context,
                animation: menuAnimation,
                animationController: menuAnimationController,
                otherController: buttonAnimationController,
                dropDownItems: widget.dropdownItems,
              );
            },
            onTapDown: (details) {
              buttonAnimationController.forward();
            },
            onTapCancel: () {
              buttonAnimationController.reverse();
            },
            child: Icon(
              Icons.more_horiz,
              key: null, //dropDownWidgetKey,
              color: buttonAnimation.value ?? AppColors.darkBrown,
              size: 36,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cubit = DI.getInstance().appSettingsCubit;
    _setItems();
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

  void _setItems() {
    appSettingsItems = _getSettingsItems(cubit.state);
    widget.dropdownItems.addAll(appSettingsItems);
  }

  List<DropDownItem> _getSettingsItems(AppSettings settings) {
    return [
      DropDownItem(
        title: 'Change theme',
        icon: Icons.light_mode_outlined,
        actions: [
          DropDownAction(
            title: AppTheme.light.name,
            onTap: () => cubit.onThemeChanged(AppTheme.light),
            isSelected: settings.theme == AppTheme.light.name,
            icon: Icons.light_mode_rounded,
          ),
          DropDownAction(
            title: AppTheme.dark.name,
            onTap: () => cubit.onThemeChanged(AppTheme.dark),
            isSelected: settings.theme == AppTheme.dark.name,
            icon: Icons.dark_mode_rounded,
          ),
          DropDownAction(
            title: AppTheme.auto.name,
            onTap: () => cubit.onThemeChanged(AppTheme.auto),
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
            title: AppLanguage.english.name,
            onTap: () => cubit.onLanguageChanged(AppLanguage.english),
            isSelected: settings.language == AppLanguage.english.name,
            icon: Icons.notes_rounded,
          ),
          DropDownAction(
            title: AppLanguage.ukrainian.name,
            onTap: () => cubit.onLanguageChanged(AppLanguage.ukrainian),
            isSelected: settings.language == AppLanguage.ukrainian.name,
            icon: Icons.notes_rounded,
          ),
        ],
      )
    ];
  }

  void rewriteItems() {
    int start = widget.dropdownItems.length - appSettingsItems.length;
    widget.dropdownItems.removeRange(start, widget.dropdownItems.length);
    _setItems();
  }

  @override
  void dispose() {
    DropDownOverlayManager.dispose();
    buttonAnimationController.dispose();
    menuAnimationController.dispose();
    super.dispose();
  }
}
