import 'package:notes/src/data/datasource/settings/app_settings/app_settings_data_source.dart';
import 'package:notes/src/domain/entity/settings/app_setting.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_state.dart';

class AppSettingsRepository {
  final AppSettingsDataSource _dataSource = AppSettingsDataSource.getInstance();

  Future<AppSettings> getSettings() async {
    return _dataSource.readSettings();
  }

  void setSetting(AppSetting setting) {
    _dataSource.writeSetting(setting);
  }
}
