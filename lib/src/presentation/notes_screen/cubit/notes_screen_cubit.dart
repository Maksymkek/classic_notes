import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/data/repository/note_repository_impl.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';
import 'package:notes/src/domain/use_case/note_case/add_note_interactor.dart';
import 'package:notes/src/domain/use_case/note_case/delete_note_interactor.dart';
import 'package:notes/src/domain/use_case/note_case/get_notes_interactor.dart';
import 'package:notes/src/domain/use_case/note_case/update_note_interactor.dart';
import 'package:notes/src/domain/use_case/note_case/update_notes_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/get_sort_by_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/get_sort_order_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/set_sort_by_interactor.dart';
import 'package:notes/src/domain/use_case/settings_case/item_settings_case/set_sort_order_interactor.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_state.dart';

class NotePageCubit extends Cubit<NotePageState> {
  NotePageCubit(
    this.folder,
  ) : super(
          NotePageState(
            sortBy: SortBy.date.name,
            sortOrder: SortOrder.descending.name,
            notes: {},
          ),
        ) {
    _init();
  }

  final Folder folder;
  late final FolderPageCubit _folderPageCubit;
  late final NoteRepository _noteRepository;
  late final GetNotesInteractor _getNotesInteractor;
  late final AddNoteInteractor _addNoteInteractor;
  late final UpdateNoteInteractor _updateNoteInteractor;
  late final DeleteNoteInteractor _deleteNoteInteractor;
  late final UpdateNotesOrderInteractor _updateNotesOrderInteractor;
  late final SetSortByInteractor _setSortByInteractor;
  late final SetSortOrderInteractor _setSortOrderInteractor;
  late final GetSortOrderInteractor _getSortOrderInteractor;
  late final GetSortByInteractor _getSortByInteractor;

  void _init() {
    _noteRepository = NoteRepositoryImpl(folder: folder);
    _getNotesInteractor = GetNotesInteractor(_noteRepository);
    _updateNotesOrderInteractor = UpdateNotesOrderInteractor(_noteRepository);
    _addNoteInteractor = AddNoteInteractor(_noteRepository);
    _updateNoteInteractor = UpdateNoteInteractor(_noteRepository);
    _deleteNoteInteractor = DeleteNoteInteractor(_noteRepository);
    var di = DI.getInstance();
    _setSortOrderInteractor = di.setSortOrderInteractor;
    _setSortByInteractor = di.setSortByInteractor;
    _getSortOrderInteractor = di.getSortOrderInteractor;
    _getSortByInteractor = di.getSortByInteractor;
    _folderPageCubit = di.folderPageCubit;
  }

  void _copyWith({
    String? sortBy,
    String? sortOrder,
    Map<int, Note>? notes,
  }) {
    emit(
      NotePageState(
        sortBy: sortBy ?? state.sortBy,
        sortOrder: sortOrder ?? state.sortOrder,
        notes: notes ?? state.notes,
      ),
    );
  }

  Future<void> onScreenLoad() async {
    final sortBy = await _getSortByInteractor(_noteRepository);
    final sortOrder = await _getSortOrderInteractor(_noteRepository);
    final folders = await getNotes();
    _copyWith(notes: folders, sortBy: sortBy, sortOrder: sortOrder);
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

  void _updateNotesOrder(Map<int, Note> notes) {
    _updateNotesOrderInteractor(notes);
    _copyWith(notes: notes);
  }

  void onItemDragged(int oldItemIndex, int newItemIndex) {
    if (oldItemIndex != newItemIndex && state.sortBy == SortBy.custom.name) {
      Map<int, Note> newNotes = {};
      for (int i = 0; i < state.notes.length; i++) {
        if (i == newItemIndex) {
          newNotes[i] = state.notes[oldItemIndex]!;
          continue;
        }
        if (oldItemIndex > newItemIndex) {
          if (i < newItemIndex || i > oldItemIndex) {
            newNotes[i] = state.notes[i]!;
          } else if (i <= oldItemIndex) {
            newNotes[i] = state.notes[i - 1]!;
            continue;
          }
        } else {
          if (i > newItemIndex || i < oldItemIndex) {
            newNotes[i] = state.notes[i]!;
          } else if (i >= oldItemIndex) {
            newNotes[i] = state.notes[i + 1]!;
            continue;
          }
        }
      }
      _updateNotesOrder(newNotes);
    }
  }

  void onSortOrderChanged(String sortOrder) {
    _setSortOrderInteractor(_noteRepository, sortOrder);
    _copyWith(sortOrder: sortOrder);
  }

  void onSortByChanged(String sortBy) {
    _setSortByInteractor(_noteRepository, sortBy);
    _copyWith(sortBy: sortBy);
  }
}
