import 'package:hive/hive.dart';
import 'package:notes/src/domain/entity/settings/setting.dart';

abstract class SettingsDataSource<GSetting extends Setting> {
  final String boxName;
  late Box box;

  SettingsDataSource(this.boxName);

  Future<void> writeSetting(GSetting setting) async {
    box = await Hive.openBox(boxName);
    await box.put(setting.key.name, setting.value);
    await box.close();
  }
}
