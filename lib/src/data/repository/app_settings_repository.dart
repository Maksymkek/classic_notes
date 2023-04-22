import 'package:notes/src/data/datasource/app_settings/app_settings_data_source.dart';
import 'package:notes/src/data/datasource/app_settings/app_settings_keys.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';
import 'package:notes/src/domain/entity/app_settings.dart';

class AppSettingsRepository {
  AppSettings settings = AppSettings(
    theme: AppTheme.light.name,
    language: AppLanguages.english.name,
  );
  final AppSettingsDataSource dataSource = AppSettingsDataSource.getInstance();

  Future<void> getSettings() async {
    settings = await dataSource.getSettings();
  }

  void setTheme(AppTheme theme) {
    dataSource.setSetting(AppSettingsKeys.theme, theme.name);
  }

  void setLanguage(AppLanguages language) {
    dataSource.setSetting(AppSettingsKeys.language, language.name);
  }
}
