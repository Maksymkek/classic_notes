import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/data/repository/folder_repository_impl.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';
import 'package:notes/src/domain/use_case/folder_case/add_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/delete_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/get_folders_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/update_folder_interactor.dart';
import 'package:notes/src/domain/use_case/folder_case/update_folders_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/get_settings_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_language_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_theme_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/get_sort_by_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/get_sort_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/set_sort_by_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/set_sort_order_interactor.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';

class DI {
  DI._();

  static DI? _instance;

  late final FolderRepository _folderRepository;
  late final GetFoldersInteractor _getFoldersInteractor;
  late final AddFolderInteractor _addFolderInteractor;
  late final UpdateFolderInteractor _updateFolderInteractor;
  late final DeleteFolderInteractor _deleteFolderInteractor;
  late final UpdateFoldersOrderInteractor _updateFoldersOrderInteractor;
  late final FolderPageCubit folderPageCubit;
  late final FolderFormCubit folderFormCubit;
  late final AppSettingsRepository appSettingsRepository;
  late final SetSortByInteractor setSortByInteractor;
  late final SetSortOrderInteractor setSortOrderInteractor;
  late final GetSortByInteractor getSortByInteractor;
  late final GetSortOrderInteractor getSortOrderInteractor;
  late final AppSettingsCubit appSettingsCubit;
  late final GetSettingsInteractor _getSettingsInteractor;
  late final SetLanguageInteractor _setLanguageInteractor;
  late final SetThemeInteractor _setThemeInteractor;

  static DI getInstance() {
    return _instance ?? (_instance = DI._());
  }

  Future<void> init() async {
    _folderRepository = FolderRepositoryImpl();
    _getFoldersInteractor = GetFoldersInteractor(_folderRepository);
    _addFolderInteractor = AddFolderInteractor(_folderRepository);
    _updateFolderInteractor = UpdateFolderInteractor(_folderRepository);
    _deleteFolderInteractor = DeleteFolderInteractor(_folderRepository);
    _updateFoldersOrderInteractor =
        UpdateFoldersOrderInteractor(_folderRepository);
    setSortByInteractor = SetSortByInteractor();
    setSortOrderInteractor = SetSortOrderInteractor();
    getSortByInteractor = GetSortByInteractor();
    getSortOrderInteractor = GetSortOrderInteractor();
    folderPageCubit = FolderPageCubit(
      _folderRepository,
      _getFoldersInteractor,
      _addFolderInteractor,
      _updateFolderInteractor,
      _deleteFolderInteractor,
      _updateFoldersOrderInteractor,
      setSortByInteractor,
      setSortOrderInteractor,
      getSortOrderInteractor,
      getSortByInteractor,
    );
    appSettingsRepository = AppSettingsRepository();

    _setLanguageInteractor = SetLanguageInteractor(appSettingsRepository);
    _setThemeInteractor = SetThemeInteractor(appSettingsRepository);
    _getSettingsInteractor = GetSettingsInteractor(appSettingsRepository);
    var settings = await _getSettingsInteractor();
    appSettingsCubit = AppSettingsCubit(
      settings,
      setThemeInteractor: _setThemeInteractor,
      setLanguageInteractor: _setLanguageInteractor,
    );
  }
}
