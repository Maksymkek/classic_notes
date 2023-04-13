import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/folder.dart';
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

import 'folder_page_state.dart';

class FolderPageCubit extends Cubit<FolderPageState> {
  FolderPageCubit(
    this._folderRepository,
    this._getFoldersInteractor,
    this._addFolderInteractor,
    this._updateFolderInteractor,
    this._deleteFolderInteractor,
    this._updateFoldersOrderInteractor,
    this._setSortByInteractor,
    this._setSortOrderInteractor,
    this._getSortOrderInteractor,
    this._getSortByInteractor,
  ) : super(
          FolderPageState(
            sortBy: SortBy.date.name,
            sortOrder: SortOrder.descending.name,
            folders: {},
          ),
        );

  final FolderRepository _folderRepository;
  final GetFoldersInteractor _getFoldersInteractor;
  final AddFolderInteractor _addFolderInteractor;
  final UpdateFolderInteractor _updateFolderInteractor;
  final DeleteFolderInteractor _deleteFolderInteractor;
  final UpdateFoldersOrderInteractor _updateFoldersOrderInteractor;
  final SetSortByInteractor _setSortByInteractor;
  final SetSortOrderInteractor _setSortOrderInteractor;
  final GetSortOrderInteractor _getSortOrderInteractor;
  final GetSortByInteractor _getSortByInteractor;

  void _copyWith({
    String? sortBy,
    String? sortOrder,
    Map<int, Folder>? folders,
  }) {
    emit(
      FolderPageState(
        sortBy: sortBy ?? state.sortBy,
        sortOrder: sortOrder ?? state.sortOrder,
        folders: folders ?? state.folders,
      ),
    );
  }

  Future<void> onScreenLoad() async {
    final sortBy = await _getSortByInteractor(_folderRepository);
    final sortOrder = await _getSortOrderInteractor(_folderRepository);
    final folders = await getFolders();
    _copyWith(folders: folders, sortBy: sortBy, sortOrder: sortOrder);
  }

  Future<Map<int, Folder>> getFolders() async {
    return await _getFoldersInteractor() ?? {};
  }

  void onAddFolderClick(Folder folder) {
    _addFolderInteractor(folder);
    onScreenLoad();
  }

  Future<void> onUpdateFolderClick(Folder folder) async {
    _updateFolderInteractor(folder);
    for (var oldFolder in state.folders.values) {
      if (oldFolder.id == folder.id) {
        if (oldFolder.name != folder.name) {
          break;
        }
      }
    }
    _copyWith(folders: await getFolders());
  }

  void onDeleteFolderClick(Folder folder) {
    _deleteFolderInteractor(folder);
    onScreenLoad();
  }

  void _updateFoldersOrder(Map<int, Folder> folders) {
    _updateFoldersOrderInteractor(folders);
    onScreenLoad();
  }

  void onItemDragged(int oldItemIndex, int newItemIndex) {
    if (oldItemIndex != newItemIndex && state.sortBy == SortBy.custom.name) {
      Map<int, Folder> newFolders = {};
      for (int i = 0; i < state.folders.length; i++) {
        if (i == newItemIndex) {
          newFolders[i] = state.folders[oldItemIndex]!;
          continue;
        }
        if (oldItemIndex > newItemIndex) {
          if (i < newItemIndex || i > oldItemIndex) {
            newFolders[i] = state.folders[i]!;
          } else if (i <= oldItemIndex) {
            newFolders[i] = state.folders[i - 1]!;
            continue;
          }
        } else {
          if (i > newItemIndex || i < oldItemIndex) {
            newFolders[i] = state.folders[i]!;
          } else if (i >= oldItemIndex) {
            newFolders[i] = state.folders[i + 1]!;
            continue;
          }
        }
      }
      _updateFoldersOrder(newFolders);
    }
  }

  void onSortOrderChanged(String sortOrder) {
    _setSortOrderInteractor(_folderRepository, sortOrder);
    _copyWith(sortOrder: sortOrder);
  }

  void onSortByChanged(String sortBy) {
    _setSortByInteractor(_folderRepository, sortBy);
    _copyWith(sortBy: sortBy);
  }
}
