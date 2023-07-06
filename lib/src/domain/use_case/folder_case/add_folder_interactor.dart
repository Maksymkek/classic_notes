import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';

class AddFolderInteractor {
  AddFolderInteractor(this.folderRepository);

  FolderRepository folderRepository;

  Future<void> call(Folder folder) async {
    await folderRepository.addFolder(folder);
  }
}
