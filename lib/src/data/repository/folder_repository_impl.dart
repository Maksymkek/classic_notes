import 'package:notes/src/data/datasource/folder_data_source.dart';
import 'package:notes/src/data/datasource/item_settings_data_source.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';

class FolderRepositoryImpl extends FolderRepository {
  final FolderDataSource folderDataSource = FolderDataSource.getInstance();

  @override
  Future<void> addFolder(Folder folder) async {
    folderDataSource.putFolder(folder);
  }

  @override
  Future<void> deleteFolder(Folder folder) async {
    folderDataSource.deleteFolder(folder);
  }

  @override
  Future<Map<int, Folder>?> getFolders() async {
    return folderDataSource.getFolders();
  }

  @override
  Future<void> updateFolder(Folder folder) async {
    folderDataSource.putFolder(folder);
  }

  @override
  Future<void> updateFoldersOrder(Map<int, Folder> folders) async {
    folderDataSource.putFolders(folders);
  }

  @override
  Future<void> updateSortByValue(String sortBy) async {
    folderDataSource.settings
        .writeSetting(ItemSettingsDataSource.sortBy, sortBy);
  }

  @override
  Future<void> updateSortOrderValue(String sortOrder) async {
    folderDataSource.settings
        .writeSetting(ItemSettingsDataSource.sortOrder, sortOrder);
  }

  @override
  Future<String> getSortByValue() async {
    return folderDataSource.settings.readSetting(ItemSettingsDataSource.sortBy);
  }

  @override
  Future<String> getSortOrderValue() async {
    return folderDataSource.settings
        .readSetting(ItemSettingsDataSource.sortOrder);
  }
}
