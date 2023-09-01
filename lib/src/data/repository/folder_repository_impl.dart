import 'package:notes/src/data/data_model/folder/folder_data_model.dart';
import 'package:notes/src/data/datasource/items/local/item_data_source.dart';
import 'package:notes/src/data/repository/item_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';

class FolderRepositoryImpl extends ItemRepositoryImpl<Folder,
    LocalItemDataSource<Folder, FolderDataModel>> {
  FolderRepositoryImpl()
      : super(
          LocalItemDataSource<Folder, FolderDataModel>(
            'folders_box',
            FolderDataModel.fromFolder,
            'folder_settings',
          ),
        );
}
