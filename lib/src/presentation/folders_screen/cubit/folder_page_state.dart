import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/folder.dart';

class FolderPageState {
  FolderPageState({
    required this.sortBy,
    required this.sortOrder,
    required this.folders,
  });

  Map<int, Folder> folders;
  String sortBy = SortBy.date.name;
  String sortOrder = SortOrder.descending.name;
}
