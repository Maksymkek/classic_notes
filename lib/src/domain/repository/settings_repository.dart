import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/settings/item_setting.dart';

abstract class SettingsRepository {
  Future<void> setSetting(ItemSetting setting);

  Future<ItemSettingsModel> getSetting();
}
