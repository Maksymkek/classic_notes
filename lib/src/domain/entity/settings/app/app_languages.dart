// ignore_for_file: unused_element

import 'package:notes/src/domain/entity/settings/app_setting.dart';
import 'package:notes/src/domain/entity/settings/settings_keys.dart';

enum AppLanguage implements AppSetting {
  english('english'),
  ukrainian('ukrainian');

  const AppLanguage(this.value, {this.key = SettingKey.language});

  @override
  final String value;

  @override
  final SettingKey key;
}
