import 'package:hive_flutter/adapters.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';

class ItemSettingsDataSource {
  ItemSettingsDataSource({required this.boxName});

  static const sortBy = 'sort_by';
  static const sortOrder = 'sort_order';
  final String boxName;

  void writeSetting(String setting, String value) async {
    final box = await Hive.openBox(boxName);
    await box.put(setting, value);
    await box.close();
  }

  Future<String> readSetting(String setting) async {
    final box = await Hive.openBox(boxName);
    var searchedSetting = box.get(setting);
    if (searchedSetting == null) {
      await box.put(sortBy, SortBy.date.name);
      await box.put(sortOrder, SortOrder.descending.name);
      searchedSetting = box.get(setting);
    }
    await box.close();
    return searchedSetting;
  }
}
