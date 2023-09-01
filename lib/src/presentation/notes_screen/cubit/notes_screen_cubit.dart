part of 'package:notes/src/presentation/interfaces/screen_cubit.dart';

class NoteScreenCubit extends ScreenCubit<Note, NotePageState> {
  NoteScreenCubit._(
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

  factory NoteScreenCubit.getInstance(Folder folder) {
    return _cache.putIfAbsent(folder.id, () => NoteScreenCubit._(folder));
  }

  static StreamSubscription<FolderScreenState>? _subscription;
  static FolderScreenState? _prevState;
  static final Map<int, NoteScreenCubit> _cache = {};
  final Folder folder;
  late final FolderScreenCubit _folderPageCubit;
  late final ItemRepository<Note> _noteRepository;
  late final GetItemsInteractor<Note> _getNotesInteractor;
  late final AddNoteInteractor _addNoteInteractor;
  late final UpdateNoteInteractor _updateNoteInteractor;
  late final DeleteNoteInteractor _deleteNoteInteractor;
  late final UpdateItemsOrderInteractor<Note> _updateNotesOrderInteractor;
  late final SetItemSettingInteractor _setItemSettingInteractor;
  late final GetItemSettingInteractor _getItemSettingInteractor;

  void _init() {
    _noteRepository = NoteRepositoryImpl(folder: folder);
    _getNotesInteractor = GetItemsInteractor(_noteRepository);
    _updateNotesOrderInteractor = UpdateItemsOrderInteractor(_noteRepository);
    _addNoteInteractor = AddNoteInteractor(_noteRepository, () {
      _folderPageCubit.onUpdateFolderClick(folder);
    });
    _updateNoteInteractor = UpdateNoteInteractor(_noteRepository, () {
      _folderPageCubit.onUpdateFolderClick(folder);
    });
    _deleteNoteInteractor = DeleteNoteInteractor(_noteRepository, () {
      _folderPageCubit.onUpdateFolderClick(folder);
    });
    var di = ServiceLocator.getInstance();
    _getItemSettingInteractor = GetItemSettingInteractor(_noteRepository);
    _setItemSettingInteractor = SetItemSettingInteractor(_noteRepository);
    _folderPageCubit = di.folderScreenCubit;
    _subscription = _subscription ??
        _folderPageCubit.stream.asBroadcastStream().listen((newState) {
          if (_prevState?.items.length == newState.items.length) {
            _prevState = newState;
            return;
          }
          _prevState = newState;
          _cache.forEach((key, value) {
            if (newState.items.getMapKey(value.folder) == -1) {
              _cache.remove(key);
            }
          });
        });
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
    var indexedNote = note.copyWith(
      id: state.items.getId(),
      dateOfLastChange: DateTime.now(),
    );
    final newNotes = _addItem(indexedNote);
    _copyWith(notes: newNotes);
    await _addNoteInteractor(indexedNote);
  }

  Future<void> onUpdateNoteClick(Note note) async {
    final newNote = note.copyWith(dateOfLastChange: DateTime.now());
    Map<int, Note> newNotes = _updateItem(newNote);
    _copyWith(notes: newNotes);
    await _updateNoteInteractor(newNote);
  }

  Future<void> onDeleteNoteClick(Note note) async {
    Map<int, Note> newNotes = _deleteItem(note);
    _copyWith(notes: reindexMap(newNotes));
    await _deleteNoteInteractor(note);
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
