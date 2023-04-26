import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/dependencies/settings/app_theme.dart';

class SetThemeInteractor {
  SetThemeInteractor(this.appSettingsRepository);
  AppSettingsRepository appSettingsRepository;
  void call(AppTheme theme) {
    return appSettingsRepository.setTheme(theme);
  }
}
