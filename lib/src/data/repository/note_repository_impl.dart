import 'package:notes/src/data/datasource/items/note_data_source.dart';
import 'package:notes/src/data/repository/item_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/note.dart';

class NoteRepositoryImpl extends ItemRepositoryImpl<Note, NoteDataSource> {
  NoteRepositoryImpl({required Folder folder}) : super(NoteDataSource(folder));
}
