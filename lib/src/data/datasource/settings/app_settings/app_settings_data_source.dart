import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/datasource/settings/settings_data_source.dart';
import 'package:notes/src/domain/entity/settings/app/app_languages.dart';
import 'package:notes/src/domain/entity/settings/app/app_theme.dart';
import 'package:notes/src/domain/entity/settings/setting.dart';
import 'package:notes/src/domain/entity/settings/settings_keys.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';

class AppSettingsDataSource extends SettingsDataSource {
  AppSettingsDataSource._() : super(_boxName);

  static AppSettingsDataSource? appSettingsDataSource;
  static const _boxName = 'app_settings_box';

  Future<AppSettings> readSettings() async {
    box = await Hive.openBox(_boxName);
    final String theme =
        box.get(SettingKey.theme.name, defaultValue: AppTheme.light.value);
    final String language = box.get(
      SettingKey.language.name,
      defaultValue: AppLanguage.english.value,
    );
    await box.close();

    return AppSettings(
      theme: Setting.getSetting(theme, AppTheme.values) ?? AppTheme.light,
      language: Setting.getSetting(language, AppLanguage.values) ??
          AppLanguage.english,
    );
  }

  static AppSettingsDataSource getInstance() {
    return appSettingsDataSource ??
        (appSettingsDataSource = AppSettingsDataSource._());
  }
}
