import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/data/repository/folder_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/repository/item_repository.dart';
import 'package:notes/src/domain/use_case/item_case/add_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/delete_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/get_items_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/update_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/update_items_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/get_settings_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_setting_interactor.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';

class DI {
  DI._();

  static DI? _instance;
  late final ItemRepository<Folder> _folderRepository;
  late final GetItemsInteractor<Folder> _getFoldersInteractor;
  late final AddItemInteractor<Folder> _addFolderInteractor;
  late final UpdateItemInteractor<Folder> _updateFolderInteractor;
  late final DeleteItemInteractor<Folder> _deleteFolderInteractor;
  late final UpdateItemsOrderInteractor<Folder> _updateFoldersOrderInteractor;
  late final FolderPageCubit folderPageCubit;
  late final FolderFormCubit folderFormCubit;
  late final AppSettingsRepository appSettingsRepository;
  late final AppSettingsCubit appSettingsCubit;
  late final GetSettingsInteractor _getSettingsInteractor;
  late final SetAppSettingInteractor _setAppSettingInteractor;

  static DI getInstance() {
    return _instance ?? (_instance = DI._());
  }

  Future<void> init() async {
    _folderRepository = FolderRepositoryImpl();
    _getFoldersInteractor = GetItemsInteractor(_folderRepository);
    _addFolderInteractor = AddItemInteractor(_folderRepository);
    _updateFolderInteractor = UpdateItemInteractor(_folderRepository);
    _deleteFolderInteractor = DeleteItemInteractor(_folderRepository);
    _updateFoldersOrderInteractor =
        UpdateItemsOrderInteractor(_folderRepository);
    folderPageCubit = FolderPageCubit(
        folderRepository: _folderRepository,
        getFoldersInteractor: _getFoldersInteractor,
        addFolderInteractor: _addFolderInteractor,
        updateFolderInteractor: _updateFolderInteractor,
        deleteFolderInteractor: _deleteFolderInteractor,
        updateFoldersOrderInteractor: _updateFoldersOrderInteractor);
    appSettingsRepository = AppSettingsRepository();

    _setAppSettingInteractor = SetAppSettingInteractor(appSettingsRepository);

    _getSettingsInteractor = GetSettingsInteractor(appSettingsRepository);
    var settings = await _getSettingsInteractor();
    appSettingsCubit = AppSettingsCubit(
      settings,
      setAppSettingInteractor: _setAppSettingInteractor,
    );
  }
}
