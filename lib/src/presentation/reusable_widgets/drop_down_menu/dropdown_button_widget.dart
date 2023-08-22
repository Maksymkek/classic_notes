import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/generated/locale_keys.g.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/domain/entity/settings/app/app_languages.dart';
import 'package:notes/src/domain/entity/settings/app/app_theme.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_cubit.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';
import 'package:notes/src/presentation/reusable_widgets/alert_dialog/alert_dialog.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';

class DropDownButtonWidget extends StatefulWidget {
  const DropDownButtonWidget({super.key, required this.dropdownItems});

  final List<DropDownItem> dropdownItems;

  @override
  State<DropDownButtonWidget> createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Color?> colorAnimation;
  late final Animation<double> scaleAnimation;
  late List<DropDownItem> settingsItems;
  late Future<void> setAppSettingsFuture;
  late AppSettingsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 6.0),
      child: BlocBuilder<AppSettingsCubit, AppSettings>(
        bloc: ServiceLocator.getInstance().appSettingsCubit,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              rewriteItems();
              DropDownOverlayManager.buildOverlay(
                context: context,
                buttonAnimationController: controller,
                dropDownItems: settingsItems,
              );
            },
            onTapDown: (details) {
              controller.forward();
            },
            onTapCancel: () {
              controller.reverse();
            },
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Icon(
                AppIcons.ellipsis,
                key: null, //dropDownWidgetKey,
                color: colorAnimation.value ?? AppColors.darkGrey,
                size: 38,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cubit = ServiceLocator.getInstance().appSettingsCubit;
    _setItems();
    controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    colorAnimation =
        ColorTween(begin: AppColors.darkGrey, end: AppColors.lightToggledGrey)
            .animate(controller);
    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(controller);
    colorAnimation.addListener(() {
      setState(() {});
    });
  }

  void _setItems() {
    settingsItems = _getAppSettingsItems(cubit.state)
      ..insertAll(0, widget.dropdownItems);
  }

  List<DropDownItem> _getAppSettingsItems(AppSettings settings) {
    return [
      DropDownItem(
        title: LocaleKeys.theme.tr(),
        icon: AppIcons.changeTheme,
        actions: [
          DropDownAction(
            title: LocaleKeys.light.tr(),
            onTap: (context) => cubit.onThemeChanged(AppTheme.light),
            isSelected: settings.theme == AppTheme.light,
            icon: AppIcons.light,
          ),
          DropDownAction(
            title: LocaleKeys.dark.tr(),
            onTap: (context) => cubit.onThemeChanged(AppTheme.dark),
            isSelected: settings.theme == AppTheme.dark,
            icon: AppIcons.dark,
          ),
          DropDownAction(
            title: LocaleKeys.auto.tr(),
            onTap: (context) => cubit.onThemeChanged(AppTheme.auto),
            isSelected: settings.theme == AppTheme.auto,
            icon: AppIcons.magic,
          ),
        ],
      ),
      DropDownItem(
        title: LocaleKeys.language.tr(),
        icon: AppIcons.planet,
        actions: [
          DropDownAction(
            title: LocaleKeys.english.tr(),
            onTap: (context) {
              cubit.onLanguageChanged(AppLanguage.english);
              AppAlertDialog.showMessageDialog(
                  context, LocaleKeys.restartForChanges.tr());
            },
            isSelected: settings.language == AppLanguage.english,
            icon: AppIcons.listItem,
          ),
          DropDownAction(
            title: LocaleKeys.ukrainian.tr(),
            onTap: (context) {
              cubit.onLanguageChanged(AppLanguage.ukrainian);
              AppAlertDialog.showMessageDialog(
                context,
                LocaleKeys.restartForChanges.tr(),
              );
            },
            isSelected: settings.language == AppLanguage.ukrainian,
            icon: AppIcons.listItem,
          ),
        ],
      ),
    ];
  }

  void rewriteItems() {
    int start = settingsItems.length - widget.dropdownItems.length;
    settingsItems.removeRange(start, settingsItems.length);
    _setItems();
  }

  @override
  void dispose() {
    DropDownOverlayManager.dispose();
    controller.dispose();
    super.dispose();
  }
}
