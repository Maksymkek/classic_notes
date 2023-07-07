import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/repository/settings_repository.dart';

class GetItemSettingInteractor {
  GetItemSettingInteractor(this.settingsRepository);

  final SettingsRepository settingsRepository;

  Future<ItemSettingsModel> call() async {
    return await settingsRepository.getSetting();
  }
}
