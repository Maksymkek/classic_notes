import 'package:hive/hive.dart';
import 'package:notes/src/data/data_model/folder/folder_data_model.dart';
import 'package:notes/src/data/data_model/note/note_data_model.dart';
import 'package:notes/src/data/datasource/items/data_source.dart';
import 'package:notes/src/data/datasource/items/item_data_source.dart';
import 'package:notes/src/data/datasource/items/note_data_source.dart';
import 'package:notes/src/data/datasource/settings/item_settings/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/item/folder.dart';

class FolderDataSource implements DataSource<Folder> {
  FolderDataSource._() {
    checkAdapter();
    _dataSource = ItemDataSource(
      boxName,
      FolderDataModel.fromFolder,
    );
  }

  late final ItemDataSource<Folder, FolderDataModel> _dataSource;

  @override
  final boxName = 'folders_box';

  @override
  ItemSettingsDataSource get settings =>
      ItemSettingsDataSource('folder_settings');
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

  @override
  Future<Map<int, Folder>> getItems() async {
    return await _dataSource.getItems();
  }

  @override
  Future<void> putItems(Map<int, Folder> folders) async {
    await _dataSource.putItems(folders);
  }

  @override
  Future<void> putItem(Folder folder) async {
    await _dataSource
        .putItem(folder.copyWith(dateOfLastChange: DateTime.now()));
  }

  @override
  Future<void> deleteItem(Folder folder) async {
    await _deleteNotes(folder);
    await _dataSource.deleteItem(folder);
  }

  Future<void> _deleteNotes(Folder folder) async {
    NoteDataSource.checkAdapter();
    var noteBox =
        await Hive.openBox<NoteDataModel>(NoteDataSource.getBoxName(folder));
    await noteBox.deleteFromDisk();
  }
}
