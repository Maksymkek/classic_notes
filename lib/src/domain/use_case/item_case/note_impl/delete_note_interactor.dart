import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/domain/use_case/item_case/note_interactor.dart';

final class DeleteNoteInteractor extends NoteInteractor {
  DeleteNoteInteractor(super.itemRepository, super.updateFolder);

  Future<void> call(Note note) async {
    await itemRepository.deleteItem(note);
    updateFolder();
  }
}
