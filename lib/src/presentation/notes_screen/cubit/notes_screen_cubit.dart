import 'package:notes/src/data/repository/note_repository_impl.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/item/note.dart';
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
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/interfaces/screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_state.dart';

class NotePageCubit extends ScreenCubit<Note, NotePageState> {
  NotePageCubit(
    this.folder,
  ) : super(
          NotePageState(
            settings: ItemSettingsModel(
              SortBy.date,
              SortOrder.descending,
            ),
            notes: {},
          ),
        ) {
    _init();
  }
  factory NotePageCubit.fromCache(Folder folder) {
    return _cache.putIfAbsent(folder.id, () => NotePageCubit(folder));
  }

  static final Map<int, NotePageCubit> _cache = {};
  final Folder folder;
  late final FolderPageCubit _folderPageCubit;
  late final ItemRepository<Note> _noteRepository;
  late final GetItemsInteractor<Note> _getNotesInteractor;
  late final AddItemInteractor<Note> _addNoteInteractor;
  late final UpdateItemInteractor<Note> _updateNoteInteractor;
  late final DeleteItemInteractor<Note> _deleteNoteInteractor;
  late final UpdateItemsOrderInteractor<Note> _updateNotesOrderInteractor;
  late final SetItemSettingInteractor _setItemSettingInteractor;
  late final GetItemSettingInteractor _getItemSettingInteractor;

  void _init() {
    _noteRepository = NoteRepositoryImpl(folder: folder);
    _getNotesInteractor = GetItemsInteractor(_noteRepository);
    _updateNotesOrderInteractor = UpdateItemsOrderInteractor(_noteRepository);
    _addNoteInteractor = AddItemInteractor(_noteRepository);
    _updateNoteInteractor = UpdateItemInteractor(_noteRepository);
    _deleteNoteInteractor = DeleteItemInteractor(_noteRepository);
    var di = ServiceLocator.getInstance();
    _getItemSettingInteractor = GetItemSettingInteractor(_noteRepository);
    _setItemSettingInteractor = SetItemSettingInteractor(_noteRepository);
    _folderPageCubit = di.folderPageCubit;
  }

  void _copyWith({
    SortBy? sortBy,
    SortOrder? sortOrder,
    Map<int, Note>? notes,
    ItemSettingsModel? settings,
  }) {
    emit(
      NotePageState(
        settings: settings ??
            ItemSettingsModel(
              sortBy ?? state.settings.sortBy,
              sortOrder ?? state.settings.sortOrder,
            ),
        notes: notes ?? state.items,
      ),
    );
  }

  Future<void> onScreenLoad() async {
    if (dropDownItems == null) {
      final settings = await _getItemSettingInteractor();
      final folders = await getNotes();
      _copyWith(notes: folders, settings: settings);
      initSettingItems();
    }
  }

  Future<Map<int, Note>> getNotes() async {
    return await _getNotesInteractor() ?? {};
  }

  Future<void> onAddNoteClick(Note note) async {
    await _folderPageCubit.onUpdateFolderClick(folder);
    await _addNoteInteractor(note);
    _copyWith(notes: await getNotes());
  }

  Future<void> onUpdateNoteClick(Note note) async {
    await _folderPageCubit.onUpdateFolderClick(folder);
    await _updateNoteInteractor(note);
    _copyWith(notes: await getNotes());
  }

  Future<void> onDeleteNoteClick(Note note) async {
    await _folderPageCubit.onUpdateFolderClick(folder);
    await _deleteNoteInteractor(note);
    _copyWith(notes: await getNotes());
  }

  @override
  void onItemDragged(int oldItemIndex, int newItemIndex) {
    final notes = updateItemOrder(oldItemIndex, newItemIndex);
    if (notes != null) {
      _updateNotesOrderInteractor(notes);
      _copyWith(notes: notes);
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
