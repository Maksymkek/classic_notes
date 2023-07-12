import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/domain/entity/settings/app_setting.dart';

class SetAppSettingInteractor {
  SetAppSettingInteractor(this.appSettingsRepository);

  AppSettingsRepository appSettingsRepository;

  void call(AppSetting setting) {
    return appSettingsRepository.setSetting(setting);
  }
}
