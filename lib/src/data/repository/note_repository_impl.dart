import 'package:notes/src/data/datasource/item_settings_data_source.dart';
import 'package:notes/src/data/datasource/note_data_source.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class NoteRepositoryImpl extends NoteRepository {
  NoteRepositoryImpl({required this.folder}) {
    _dataSource = NoteDataSource(folder);
  }
  final Folder folder;
  late final NoteDataSource _dataSource;

  @override
  Future<void> addNote(Note note) async {
    await _dataSource.putNote(note);
  }

  @override
  Future<void> deleteNote(Note note) async {
    await _dataSource.deleteNote(note);
  }

  @override
  Future<Map<int, Note>?> getNotes() async {
    return _dataSource.getNotes();
  }

  @override
  Future<void> updateNote(Note note) async {
    await _dataSource.putNote(note);
  }

  @override
  Future<void> updateNotesOrder(Map<int, Note> notes) async {
    await _dataSource.putNotes(notes);
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
