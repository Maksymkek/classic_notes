// ignore_for_file: unused_element

import 'package:notes/src/domain/entity/settings/item_setting.dart';
import 'package:notes/src/domain/entity/settings/settings_keys.dart';

enum SortOrder implements ItemSetting {
  descending('descending'),
  ascending('ascending');

  const SortOrder(this.value, {this.key = SettingKey.sort_order});

  @override
  final String value;

  @override
  final SettingKey key;
}
