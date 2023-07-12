// ignore_for_file: unused_element

import 'package:notes/src/domain/entity/settings/item_setting.dart';
import 'package:notes/src/domain/entity/settings/settings_keys.dart';

enum SortBy implements ItemSetting {
  date('date'),
  name('name'),
  custom('custom');

  const SortBy(this.value, {this.key = SettingKey.sort_by});

  @override
  final String value;

  @override
  final SettingKey key;
}
