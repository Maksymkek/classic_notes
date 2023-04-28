import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class UpdateNotesOrderInteractor {
  UpdateNotesOrderInteractor(this.noteRepository);

  NoteRepository noteRepository;

  Future<void> call(Map<int, Note> notes) async {
    await noteRepository.updateNotesOrder(notes);
  }
}
