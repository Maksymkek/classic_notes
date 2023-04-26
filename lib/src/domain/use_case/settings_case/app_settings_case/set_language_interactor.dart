import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/dependencies/settings/app_languages.dart';

class SetLanguageInteractor {
  SetLanguageInteractor(this.appSettingsRepository);
  AppSettingsRepository appSettingsRepository;
  void call(AppLanguage language) {
    return appSettingsRepository.setLanguage(language);
  }
}
