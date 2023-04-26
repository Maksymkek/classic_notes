import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class UpdateNoteInteractor {
  UpdateNoteInteractor(this.noteRepository);

  NoteRepository noteRepository;

  void call(Note note) {
    noteRepository.updateNote(note);
  }
}
