import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/repository/folder_repository.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';

class MockFolderRepository extends FolderRepository {
  final Map<int, Folder> _folders = {
    0: Folder(
      id: 0,
      name: 'Quick notes',
      background: AppColors.darkBrown,
      icon: const Icon(
        AppIcons.folder,
        size: 28,
        color: AppColors.milkWhite,
      ),
      dateOfLastChange: DateTime.now(),
    ),
    1: Folder(
      id: 1,
      name: 'Best media',
      background: AppColors.milkWhite,
      icon: const Icon(AppIcons.media, size: 32, color: AppColors.darkBrown),
      dateOfLastChange: DateTime.now(),
    ),
    2: Folder(
      id: 2,
      name: 'Music that shazam didn\'t recognize',
      background: AppColors.carmineRed,
      icon: const Icon(
        AppIcons.music,
        size: 34,
        color: AppColors.milkWhite,
      ),
      dateOfLastChange: DateTime.now(),
    ),
    3: Folder(
      id: 3,
      name: 'Pills to buy',
      background: AppColors.sapphireBlue,
      icon: const Icon(
        AppIcons.medicine,
        size: 26,
        color: AppColors.milkWhite,
      ),
      dateOfLastChange: DateTime.now(),
    ),
  };
  String _sortOrder = SortOrder.descending.name;
  String _sortBy = SortBy.date.name;

  int? getFolderById(Folder updatedFolder) {
    int? searchedFolderId;
    for (int i = 0; i < _folders.length; i++) {
      var folder = _folders[i];
      if (folder?.id == updatedFolder.id) {
        searchedFolderId = folder?.id;
      }
    }
    return searchedFolderId;
  }

  @override
  Future<void> addFolder(Folder folder) async {
    _folders[_folders.length] = folder;
  }

  @override
  Future<void> deleteFolder(Folder folder) async {
    var key = _folders.values.toList().indexOf(folder);
    while (key < _folders.length - 1) {
      _folders[key] = _folders[key + 1]!;
      key += 1;
    }
    _folders.remove(_folders.length - 1);
  }

  @override
  Future<Map<int, Folder>?> getFolders() async {
    return Map.from(_folders);
  }

  @override
  Future<void> updateFolder(Folder folder) async {
    try {
      _folders.update(
        getFolderById(folder)!,
        (value) => folder,
      );
    } on Exception catch (_) {}
  }

  @override
  Future<void> updateFoldersOrder(Map<int, Folder> folders) async {
    folders.forEach((key, folder) {
      _folders.update(key, (oldFolder) => folder);
    });
  }

  @override
  Future<void> updateSortByValue(String sortBy) async {
    _sortBy = sortBy;
  }

  @override
  Future<void> updateSortOrderValue(String sortOrder) async {
    _sortOrder = sortOrder;
  }

  @override
  Future<String> getSortByValue() async {
    return _sortBy;
  }

  @override
  Future<String> getSortOrderValue() async {
    return _sortOrder;
  }
}
