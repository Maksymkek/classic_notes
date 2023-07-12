// ignore_for_file: unused_element

import 'package:notes/src/domain/entity/settings/app_setting.dart';
import 'package:notes/src/domain/entity/settings/settings_keys.dart';

enum AppTheme implements AppSetting {
  light('light'),
  dark('dark'),
  auto('auto');

  const AppTheme(this.value, {this.key = SettingKey.theme});

  @override
  final String value;

  @override
  final SettingKey key;
}
