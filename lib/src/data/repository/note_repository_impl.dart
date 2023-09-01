import 'package:notes/src/data/data_model/note/note_data_model.dart';
import 'package:notes/src/data/datasource/items/local/item_data_source.dart';
import 'package:notes/src/data/repository/item_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/note.dart';

class NoteRepositoryImpl
    extends ItemRepositoryImpl<Note, LocalItemDataSource<Note, NoteDataModel>> {
  NoteRepositoryImpl({required Folder folder})
      : super(
          LocalItemDataSource<Note, NoteDataModel>(
            _getBoxName(folder),
            NoteDataModel.fromNote,
            'note_settings',
          ),
        );

  static String _getBoxName(Folder folder) => 'folder_${folder.id}_note_box';
}
