import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_language_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_theme_interactor.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettings> {
  AppSettingsCubit(super.initialState,
      {required this.setThemeInteractor, required this.setLanguageInteractor});

  final SetLanguageInteractor setLanguageInteractor;
  final SetThemeInteractor setThemeInteractor;

  void _copyWith({AppTheme? appTheme, AppLanguage? appLanguage}) {
    emit(
      AppSettings(
        theme: appTheme?.name ?? state.theme,
        language: appLanguage?.name ?? state.language,
      ),
    );
  }

  void onThemeChanged(AppTheme appTheme) {
    setThemeInteractor(appTheme);
    _copyWith(appTheme: appTheme);
  }

  void onLanguageChanged(AppLanguage appLanguage) {
    setLanguageInteractor(appLanguage);
    _copyWith(appLanguage: appLanguage);
  }
}
