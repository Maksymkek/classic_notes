import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/note.dart';

class NotePageState {
  NotePageState({
    required this.sortBy,
    required this.sortOrder,
    required this.notes,
  });

  Map<int, Note> notes;
  String sortBy = SortBy.date.name;
  String sortOrder = SortOrder.descending.name;
}
