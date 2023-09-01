import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/data/datasource/settings/settings_data_source.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';
import 'package:notes/src/domain/entity/settings/item_setting.dart';
import 'package:notes/src/domain/entity/settings/setting.dart';
import 'package:notes/src/domain/entity/settings/settings_keys.dart';

class ItemSettingsDataSource extends SettingsDataSource<ItemSetting> {
  ItemSettingsDataSource(super.boxName);

  Future<ItemSettingsModel> readSettings() async {
    box = await Hive.openBox(boxName);
    String sortBy =
        box.get(SettingKey.sort_by.name, defaultValue: SortBy.date.value);
    String sortOrder = box.get(
      SettingKey.sort_order.name,
      defaultValue: SortOrder.descending.value,
    );
    final itemSettings = ItemSettingsModel(
      Setting.getSetting(sortBy, SortBy.values) ?? SortBy.date,
      Setting.getSetting(sortOrder, SortOrder.values) ?? SortOrder.descending,
    );
    await box.close();
    return itemSettings;
  }
}
