import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/domain/use_case/item_case/note_interactor.dart';

final class UpdateNoteInteractor extends NoteInteractor {
  UpdateNoteInteractor(super.itemRepository, super.updateFolder);

  Future<void> call(Note note) async {
    await itemRepository.updateItem(note);
    updateFolder();
  }
}
