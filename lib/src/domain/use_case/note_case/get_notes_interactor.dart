import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class GetNotesInteractor {
  GetNotesInteractor(this.noteRepository);

  NoteRepository noteRepository;

  Future<Map<int, Note>?> call() {
    return noteRepository.getNotes();
  }
}
