import 'package:notes/src/domain/entity/settings/item_setting.dart';
import 'package:notes/src/domain/repository/settings_repository.dart';

class SetItemSettingInteractor {
  SetItemSettingInteractor(this.settingsRepository);

  final SettingsRepository settingsRepository;

  void call(ItemSetting setting) {
    settingsRepository.setSetting(setting);
  }
}
