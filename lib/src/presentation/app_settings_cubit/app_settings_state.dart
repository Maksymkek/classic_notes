
import 'package:notes/src/domain/entity/settings/app/app_languages.dart';
import 'package:notes/src/domain/entity/settings/app/app_theme.dart';

class AppSettings {
  AppSettings({required this.theme, required this.language});

  AppTheme theme;
  AppLanguage language;
}
