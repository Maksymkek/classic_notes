import 'package:hive/hive.dart';
import 'package:notes/src/data/data_model/folder_data_model.dart';
import 'package:notes/src/data/data_model/note_data_model.dart';
import 'package:notes/src/data/datasource/item_settings_data_source.dart';
import 'package:notes/src/data/datasource/note_data_source.dart';
import 'package:notes/src/domain/entity/folder.dart';

class FolderDataSource {
  FolderDataSource._() {
    checkAdapter();
  }

  static const _boxName = 'folders_box';
  late Box<FolderDataModel> box;
  final ItemSettingsDataSource settings =
      ItemSettingsDataSource(boxName: 'folder_settings');
  static FolderDataSource? _folderDataSource;

  static FolderDataSource getInstance() {
    return _folderDataSource ?? (FolderDataSource._());
  }

  static void checkAdapter() {
    final folderDataModelAdapter = FolderDataModelAdapter();
    if (!Hive.isAdapterRegistered(folderDataModelAdapter.typeId)) {
      Hive.registerAdapter(folderDataModelAdapter);
    }
  }

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
      (key, folder) =>
          MapEntry(key, FolderDataModel.fromFolder(folder, folder.id)),
    );
    await box.putAll(folderModels);
    await box.close();
  }

  Future<void> putFolder(Folder folder) async {
    final updatedFolder = folder.copyWith(dateOfLastChange: DateTime.now());
    box = await Hive.openBox<FolderDataModel>(_boxName);
    int id = updatedFolder.id;
    int key = _indexOf(folder);
    if (id == -1) {
      id = _getId(box);
      key = box.keys.length;
    }
    await box.put(key, FolderDataModel.fromFolder(updatedFolder, id));
    await box.close();
  }

  Future<void> deleteFolder(Folder folder) async {
    NoteDataSource.checkAdapter();
    var noteBox =
        await Hive.openBox<NoteDataModel>(NoteDataSource.getBoxName(folder));
    await noteBox.deleteFromDisk();
    box = await Hive.openBox<FolderDataModel>(_boxName);
    await box.delete(_indexOf(folder));
    var values = box.values.toList();
    await box.deleteAll(box.keys);
    for (int i = 0; i < values.length; i += 1) {
      await box.put(i, values[i]);
    }
    await box.close();
  }

  int _getId(Box<FolderDataModel> box) {
    final idList = box.values.map((e) => e.id).toList();
    if (idList.isEmpty) {
      return 0;
    }
    idList.sort();
    var newId = idList.last + 1;
    return newId;
  }

  int _indexOf(Folder folder) {
    int i = 0;
    for (var value in box.values) {
      if (value.id == folder.id) {
        return i;
      }
      i += 1;
    }
    return -1;
  }
}
