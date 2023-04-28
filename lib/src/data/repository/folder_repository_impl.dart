import 'package:notes/src/data/datasource/folder_data_source.dart';
import 'package:notes/src/data/datasource/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';

class FolderRepositoryImpl extends FolderRepository {
  final FolderDataSource _dataSource = FolderDataSource.getInstance();

  @override
  Future<void> addFolder(Folder folder) async {
    await _dataSource.putFolder(folder);
  }

  @override
  Future<void> deleteFolder(Folder folder) async {
    await _dataSource.deleteFolder(folder);
  }

  @override
  Future<Map<int, Folder>?> getFolders() async {
    return _dataSource.getFolders();
  }

  @override
  Future<void> updateFolder(Folder folder) async {
    await _dataSource.putFolder(folder);
  }

  @override
  Future<void> updateFoldersOrder(Map<int, Folder> folders) async {
    await _dataSource.putFolders(folders);
  }

  @override
  Future<void> updateSortByValue(String sortBy) async {
    _dataSource.settings.writeSetting(ItemSettingsDataSource.sortBy, sortBy);
  }

  @override
  Future<void> updateSortOrderValue(String sortOrder) async {
    _dataSource.settings
        .writeSetting(ItemSettingsDataSource.sortOrder, sortOrder);
  }

  @override
  Future<String> getSortByValue() async {
    return _dataSource.settings.readSetting(ItemSettingsDataSource.sortBy);
  }

  @override
  Future<String> getSortOrderValue() async {
    return _dataSource.settings.readSetting(ItemSettingsDataSource.sortOrder);
  }
}
