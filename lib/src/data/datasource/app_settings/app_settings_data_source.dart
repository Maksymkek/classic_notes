import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/datasource/app_settings/app_settings_keys.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';
import 'package:notes/src/domain/entity/app_settings.dart';

class AppSettingsDataSource {
  AppSettingsDataSource._();

  static AppSettingsDataSource? appSettingsDataSource;
  static const _boxName = 'app_settings_box';
  late Box _box;
  static const _themeKey = 'theme';
  static const _languageKey = 'language';

  Future<AppSettings> getSettings() async {
    _box = await Hive.openBox(_boxName);
    final String theme = _box.get(_themeKey, defaultValue: AppTheme.light.name);
    final String language =
        _box.get(_languageKey, defaultValue: AppLanguages.english.name);
    await _box.close();
    return AppSettings(theme: theme, language: language);
  }

  Future<void> setSetting(AppSettingsKeys key, String value) async {
    _box = await Hive.openBox(_boxName);
    await _box.put(key.name, value);
    await _box.close();
  }

  static AppSettingsDataSource getInstance() {
    return appSettingsDataSource ??
        (appSettingsDataSource = AppSettingsDataSource._());
  }
}
