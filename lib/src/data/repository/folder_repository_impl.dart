import 'package:notes/src/data/datasource/items/folder_data_source.dart';
import 'package:notes/src/data/repository/item_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';

class FolderRepositoryImpl
    extends ItemRepositoryImpl<Folder, FolderDataSource> {
  FolderRepositoryImpl() : super(FolderDataSource.getInstance());
}
