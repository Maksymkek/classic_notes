import 'package:notes/src/domain/entity/app_settings.dart';

class AppSettingsRepository {
  final AppSettings _settings = AppSettings(theme: 'light');

  AppSettings getSettings() {
    return _settings;
  }

  void setTheme(String theme) {
    _settings.theme = theme;
  }
}
