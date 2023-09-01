import 'package:notes/src/data/repository/note_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/delete_item_interactor.dart';

final class DeleteFolderInteractor extends DeleteItemInteractor<Folder> {
  DeleteFolderInteractor(super.itemRepository);

  @override
  Future<void> call(Folder item) async {
    await itemRepository.deleteItem(item);
    NoteRepositoryImpl(folder: item).deleteAll();
  }
}
