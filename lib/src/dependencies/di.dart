import 'package:notes/src/data/repository/app_settings_repository.dart';
import 'package:notes/src/data/repository/folder_repository_impl.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/repository/item_repository.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/add_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/get_items_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/update_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/base_impl/update_items_order_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/folder_impl/delete_folder_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/get_settings_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/app_settings_case/set_setting_interactor.dart';
import 'package:notes/src/presentation/app_settings_cubit/app_settings_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/interfaces/screen_cubit.dart';

class ServiceLocator {
  ServiceLocator._();

  static ServiceLocator? _instance;
  late final ItemRepository<Folder> _folderRepository;
  late final GetItemsInteractor<Folder> _getFoldersInteractor;
  late final AddItemInteractor<Folder> _addFolderInteractor;
  late final UpdateItemInteractor<Folder> _updateFolderInteractor;
  late final DeleteFolderInteractor _deleteFolderInteractor;
  late final UpdateItemsOrderInteractor<Folder> _updateFoldersOrderInteractor;
  late final FolderScreenCubit folderScreenCubit;
  late final FolderFormCubit folderFormCubit;
  late final AppSettingsRepository appSettingsRepository;
  late final AppSettingsCubit appSettingsCubit;
  late final GetSettingsInteractor _getSettingsInteractor;
  late final SetAppSettingInteractor _setAppSettingInteractor;

  static ServiceLocator getInstance() {
    return _instance ?? (_instance = ServiceLocator._());
  }

  Future<void> init() async {
    _folderRepository = FolderRepositoryImpl();
    _getFoldersInteractor = GetItemsInteractor(_folderRepository);
    _addFolderInteractor = AddItemInteractor(_folderRepository);
    _updateFolderInteractor = UpdateItemInteractor(_folderRepository);
    _deleteFolderInteractor = DeleteFolderInteractor(_folderRepository);
    _updateFoldersOrderInteractor =
        UpdateItemsOrderInteractor(_folderRepository);
    folderScreenCubit = FolderScreenCubit(
      folderRepository: _folderRepository,
      getFoldersInteractor: _getFoldersInteractor,
      addFolderInteractor: _addFolderInteractor,
      updateFolderInteractor: _updateFolderInteractor,
      deleteFolderInteractor: _deleteFolderInteractor,
      updateFoldersOrderInteractor: _updateFoldersOrderInteractor,
    );
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
