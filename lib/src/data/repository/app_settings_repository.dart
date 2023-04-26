import 'package:notes/src/data/datasource/app_settings/app_settings_data_source.dart';
import 'package:notes/src/data/datasource/app_settings/app_settings_keys.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';

class AppSettingsRepository {
  final AppSettingsDataSource _dataSource = AppSettingsDataSource.getInstance();

  Future<AppSettings> getSettings() async {
    return _dataSource.getSettings();
  }

  void setTheme(AppTheme theme) {
    _dataSource.setSetting(AppSettingsKeys.theme, theme.name);
  }

  void setLanguage(AppLanguage language) {
    _dataSource.setSetting(AppSettingsKeys.language, language.name);
  }
}
