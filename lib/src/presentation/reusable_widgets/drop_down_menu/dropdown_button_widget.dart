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
              AppIcons.ellipsis,
              key: null, //dropDownWidgetKey,
              color: buttonAnimation.value ?? AppColors.darkBrown,
              size: 34,
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
        title: LocaleKeys.theme.tr(),
        icon: AppIcons.changeTheme,
        actions: [
          DropDownAction(
            title: LocaleKeys.light.tr(),
            onTap: () => cubit.onThemeChanged(AppTheme.light),
            isSelected: settings.theme == AppTheme.light,
            icon: AppIcons.light,
          ),
          DropDownAction(
            title: LocaleKeys.dark.tr(),
            onTap: () => cubit.onThemeChanged(AppTheme.dark),
            isSelected: settings.theme == AppTheme.dark,
            icon: AppIcons.dark,
          ),
          DropDownAction(
            title: LocaleKeys.auto.tr(),
            onTap: () => cubit.onThemeChanged(AppTheme.auto),
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
            onTap: () => cubit.onLanguageChanged(AppLanguage.english),
            isSelected: settings.language == AppLanguage.english,
            icon: AppIcons.listItem,
          ),
          DropDownAction(
            title: LocaleKeys.ukrainian.tr(),
            onTap: () => cubit.onLanguageChanged(AppLanguage.ukrainian),
            isSelected: settings.language == AppLanguage.ukrainian,
            icon: AppIcons.listItem,
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

    super.dispose();
  }
}
