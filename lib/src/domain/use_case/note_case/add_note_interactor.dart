import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class AddNoteInteractor {
  AddNoteInteractor(this.noteRepository);

  NoteRepository noteRepository;

  Future<void> call(Note note) async {
    await noteRepository.addNote(note);
  }
}
