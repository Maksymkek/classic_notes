import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/settings/item/sort_by.dart';
import 'package:notes/src/domain/entity/settings/item/sort_order.dart';
import 'package:notes/src/domain/repository/item_repository.dart';
import 'package:notes/src/domain/use_case/item_case/add_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/delete_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/get_items_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/update_item_interactor.dart';
import 'package:notes/src/domain/use_case/item_case/update_items_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/get_setting_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/set_setting_interactor.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_state.dart';
import 'package:notes/src/presentation/interfaces/screen_cubit.dart';

class FolderScreenCubit extends ScreenCubit<Folder, FolderPageState> {
  FolderScreenCubit({
    required this.folderRepository,
    required this.getFoldersInteractor,
    required this.addFolderInteractor,
    required this.updateFolderInteractor,
    required this.deleteFolderInteractor,
    required this.updateFoldersOrderInteractor,
  }) : super(
          FolderPageState(
            settings: ItemSettingsModel(SortBy.date, SortOrder.descending),
            folders: {},
          ),
        ) {
    _setItemSettingInteractor = SetItemSettingInteractor(folderRepository);
    _getItemSettingInteractor = GetItemSettingInteractor(folderRepository);
  }

  final ItemRepository<Folder> folderRepository;
  final GetItemsInteractor<Folder> getFoldersInteractor;
  final AddItemInteractor<Folder> addFolderInteractor;
  final UpdateItemInteractor<Folder> updateFolderInteractor;
  final DeleteItemInteractor<Folder> deleteFolderInteractor;
  final UpdateItemsOrderInteractor<Folder> updateFoldersOrderInteractor;
  late final SetItemSettingInteractor _setItemSettingInteractor;
  late final GetItemSettingInteractor _getItemSettingInteractor;

  void _copyWith({
    SortBy? sortBy,
    SortOrder? sortOrder,
    Map<int, Folder>? folders,
    ItemSettingsModel? settings,
  }) {
    emit(
      FolderPageState(
        settings: settings ??
            ItemSettingsModel(
              sortBy ?? state.settings.sortBy,
              sortOrder ?? state.settings.sortOrder,
            ),
        folders: folders ?? state.items,
      ),
    );
  }

  Future<void> onScreenLoad() async {
    final settings = await _getItemSettingInteractor();
    final folders = await getFolders();
    _copyWith(folders: folders, settings: settings);
    initSettingItems();
  }

  Future<Map<int, Folder>> getFolders() async {
    return await getFoldersInteractor() ?? {};
  }

  Future<void> onAddFolderClick(Folder folder) async {
    await addFolderInteractor(folder);
    Map<int, Folder> newFolders = Map.from(state.items)
      ..[state.items.length] =
          folder.copyWith(id: getId(), dateOfLastChange: DateTime.now());
    _copyWith(folders: newFolders);
  }

  Future<void> onUpdateFolderClick(Folder folder) async {
    await updateFolderInteractor(folder);
    Map<int, Folder> newFolders = Map.from(state.items)
      ..update(
        getMapKey(folder),
        (value) => folder.copyWith(dateOfLastChange: DateTime.now()),
      );
    _copyWith(folders: newFolders);
  }

  Future<void> onDeleteFolderClick(Folder folder) async {
    await deleteFolderInteractor(folder);
    Map<int, Folder> newFolders = Map.from(state.items)
      ..removeWhere((key, value) => value == folder);
    _copyWith(folders: reindexMap(newFolders));
  }

  @override
  void onItemDragged(int oldItemIndex, int newItemIndex) {
    final folders = updateItemOrder(oldItemIndex, newItemIndex);
    if (folders != null) {
      updateFoldersOrderInteractor(folders);
      _copyWith(folders: folders);
    }
  }

  @override
  void onSortOrderChanged(SortOrder sortOrder) {
    _setItemSettingInteractor(sortOrder);
    _copyWith(sortOrder: sortOrder);
  }

  @override
  void onSortByChanged(SortBy sortBy) {
    _setItemSettingInteractor(sortBy);
    _copyWith(sortBy: sortBy);
  }
}
