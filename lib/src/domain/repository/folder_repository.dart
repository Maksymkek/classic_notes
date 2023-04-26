import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/settings_repository.dart';

abstract class FolderRepository implements SettingsRepository {
  Future<Map<int, Folder>?> getFolders();

  Future<void> addFolder(Folder folder);

  Future<void> updateFolder(Folder folder);

  Future<void> deleteFolder(Folder folder);

  Future<void> updateFoldersOrder(Map<int, Folder> folders);
}
