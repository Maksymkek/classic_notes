import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/settings_repository.dart';

abstract class NoteRepository implements SettingsRepository {
  Future<Map<int, Note>?> getNotes();

  Future<void> addNote(Note note);

  Future<void> updateNote(Note note);

  Future<void> deleteNote(Note note);

  Future<void> updateNotesOrder(Map<int, Note> notes);
}
