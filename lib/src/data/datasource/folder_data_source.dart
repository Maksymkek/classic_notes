import 'package:hive/hive.dart';
import 'package:notes/src/data/data_model/folder_data_model.dart';
import 'package:notes/src/data/datasource/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/folder.dart';

class FolderDataSource {
  FolderDataSource._() {
    Hive.registerAdapter(FolderDataModelAdapter());
  }

  static const _boxName = 'folders_box';
  late Box<FolderDataModel> box;
  final ItemSettingsDataSource settings =
      ItemSettingsDataSource(boxName: 'folder_settings');
  static FolderDataSource? _folderDataSource;

  Future<Map<int, Folder>> getFolders() async {
    box = await Hive.openBox<FolderDataModel>(_boxName);
    final mapFrom = box.keys.toList();
    Map<int, Folder> folders = {};
    for (int i = 0; i < mapFrom.length; i++) {
      folders[i] = box.get(mapFrom[i])!.toFolder();
    }
    await box.close();
    return folders;
  }

  Future<void> putFolders(Map<int, Folder> folders) async {
    box = await Hive.openBox<FolderDataModel>(_boxName);
    final Map<int, FolderDataModel> folderModels = folders.map(
      (key, folder) => MapEntry(key, FolderDataModel.fromFolder(folder, key)),
    );
    await box.putAll(folderModels);
    await box.close();
  }

  Future<void> putFolder(Folder folder) async {
    box = await Hive.openBox<FolderDataModel>(_boxName);
    int key = folder.id;
    if (key == -1) {
      key = _getKey(key, box);
    }
    await box.put(key, FolderDataModel.fromFolder(folder, key));
    await box.close();
  }

  Future<void> deleteFolder(Folder folder) async {
    box = await Hive.openBox<FolderDataModel>(_boxName);
    await box.delete(folder.id);
    await box.close();
  }

  static FolderDataSource getInstance() {
    return _folderDataSource ?? (FolderDataSource._());
  }

  int _getKey(int key, Box<FolderDataModel> box) {
    final List keys = box.keys.toList().map((e) => (e as int)).toList();
    if (keys.isEmpty) {
      return 0;
    }
    keys.sort();
    key = keys.last + 1;
    return key;
  }
}
