import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';

class DeleteFolderInteractor {
  DeleteFolderInteractor(this.folderRepository);

  FolderRepository folderRepository;

  Future<void> call(Folder folder) async {
    await folderRepository.deleteFolder(folder);
  }
}
