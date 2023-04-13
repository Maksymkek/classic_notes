import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/data/repository/folder_repository_impl.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';
import 'package:notes/src/domain/use_case/folder_case/add_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/delete_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/get_folders_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/update_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/update_folders_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/get_sort_by_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/get_sort_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/set_sort_by_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/set_sort_order_interactor.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';

class DI {
  DI._();

  static DI? _instance;

  late FolderRepository _folderRepository;
  late GetFoldersInteractor _getFoldersInteractor;
  late AddFolderInteractor _addFolderInteractor;
  late UpdateFolderInteractor _updateFolderInteractor;
  late DeleteFolderInteractor _deleteFolderInteractor;
  late UpdateFoldersOrderInteractor _updateFoldersOrderInteractor;
  late FolderPageCubit folderPageCubit;
  late FolderFormCubit folderFormCubit;
  late AppSettingsRepository appSettingsRepository;
  late SetSortByInteractor _setSortByInteractor;
  late SetSortOrderInteractor _setSortOrderInteractor;
  late GetSortByInteractor _getSortByInteractor;
  late GetSortOrderInteractor _getSortOrderInteractor;

  static DI getInstance() {
    return _instance ?? (_instance = DI._());
  }

  Future<void> init() async {
    _folderRepository = MockFolderRepository();
    _getFoldersInteractor = GetFoldersInteractor(_folderRepository);
    _addFolderInteractor = AddFolderInteractor(_folderRepository);
    _updateFolderInteractor = UpdateFolderInteractor(_folderRepository);
    _deleteFolderInteractor = DeleteFolderInteractor(_folderRepository);
    _updateFoldersOrderInteractor =
        UpdateFoldersOrderInteractor(_folderRepository);
    _setSortByInteractor = SetSortByInteractor();
    _setSortOrderInteractor = SetSortOrderInteractor();
    _getSortByInteractor = GetSortByInteractor();
    _getSortOrderInteractor = GetSortOrderInteractor();
    folderPageCubit = FolderPageCubit(
      _folderRepository,
      _getFoldersInteractor,
      _addFolderInteractor,
      _updateFolderInteractor,
      _deleteFolderInteractor,
      _updateFoldersOrderInteractor,
      _setSortByInteractor,
      _setSortOrderInteractor,
      _getSortOrderInteractor,
      _getSortByInteractor,
    );
    appSettingsRepository = AppSettingsRepository();
  }
}
