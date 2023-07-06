import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class UpdateNoteInteractor {
  UpdateNoteInteractor(this.noteRepository);

  NoteRepository noteRepository;

  Future<void> call(Note note) async {
    await noteRepository.updateNote(note);
  }
}
