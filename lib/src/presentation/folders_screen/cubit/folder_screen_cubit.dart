part of 'package:notes/src/presentation/interfaces/screen_cubit.dart';

class FolderScreenCubit extends ScreenCubit<Folder, FolderScreenState> {
  FolderScreenCubit({
    required this.folderRepository,
    required this.getFoldersInteractor,
    required this.addFolderInteractor,
    required this.updateFolderInteractor,
    required this.deleteFolderInteractor,
    required this.updateFoldersOrderInteractor,
  }) : super(
          FolderScreenState(
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
  final DeleteFolderInteractor deleteFolderInteractor;
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
      FolderScreenState(
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
    final indexedFolder = folder.copyWith(
      id: state.items.getId(),
      dateOfLastChange: DateTime.now(),
    );
    final newFolders = _addItem(indexedFolder);
    _copyWith(folders: newFolders);
    await addFolderInteractor(indexedFolder);
  }

  Future<void> onUpdateFolderClick(Folder folder) async {
    final newFolder = folder.copyWith(dateOfLastChange: DateTime.now());
    Map<int, Folder> newFolders = _updateItem(newFolder);
    _copyWith(folders: newFolders);
    await updateFolderInteractor(folder);
  }

  Future<void> onDeleteFolderClick(Folder folder) async {
    Map<int, Folder> newFolders = _deleteItem(folder);
    _copyWith(folders: newFolders);
    await deleteFolderInteractor(folder);
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
