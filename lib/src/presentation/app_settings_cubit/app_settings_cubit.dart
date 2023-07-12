import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/settings/app/app_languages.dart';
import 'package:notes/src/domain/entity/settings/app/app_theme.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_setting_interactor.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettings> {
  AppSettingsCubit(
    super.initialState, {
    required this.setAppSettingInteractor,
  });

  final SetAppSettingInteractor setAppSettingInteractor;

  void _copyWith({AppTheme? appTheme, AppLanguage? appLanguage}) {
    emit(
      AppSettings(
        theme: appTheme ?? state.theme,
        language: appLanguage ?? state.language,
      ),
    );
  }

  void onThemeChanged(AppTheme appTheme) {
    setAppSettingInteractor(appTheme);
    _copyWith(appTheme: appTheme);
  }

  void onLanguageChanged(AppLanguage appLanguage) {
    setAppSettingInteractor(appLanguage);
    _copyWith(appLanguage: appLanguage);
  }
}
