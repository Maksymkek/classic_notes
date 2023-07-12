import 'package:notes/src/domain/entity/settings/settings_keys.dart';

abstract class Setting {
  final SettingKey key;
  final String value;

  static T? getSetting<T extends Setting>(
      String searchedSetting, Iterable<T> values) {
    for (var value in values) {
      if (value.value == searchedSetting) {
        return value;
      }
    }
    return null;
  }

  Setting(this.value, this.key);
}
