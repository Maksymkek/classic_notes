import 'package:notes/src/dependencies/settings/sort_by.dart';
import 'package:notes/src/dependencies/settings/sort_order.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/domain/repository/note_repository.dart';

class MockNoteRepositoryImpl extends NoteRepository {
  MockNoteRepositoryImpl({required this.folder});
  final Folder folder;
  final Map<int, Note> notesMap = {
    0: Note(
      id: 0,
      name: 'Парацетомол',
      dateOfLastChange: DateTime.now(),
      text: 'Аптека низких цен - 150\nАптека добра - 100',
    ),
    1: Note(
      id: 1,
      name: 'Риназолин',
      dateOfLastChange: DateTime.now(),
      text: 'Аптека низких цен - 100\nАптека добра - 110',
    ),
    2: Note(
      id: 2,
      name: 'Нафтизин',
      dateOfLastChange: DateTime.now(),
      text: 'Аптека низких цен - 80\nАптека добра - 90',
    ),
    3: Note(
      id: 3,
      name: 'Оттофлокс',
      dateOfLastChange: DateTime.now(),
      text: 'Аптека низких цен - 140\nАптека добра - 140',
    ),
    4: Note(
      id: 4,
      name: 'My test folder is simple text that i use here',
      dateOfLastChange: DateTime.now(),
      text: 'Lorem ipsum dolor sit amet el mena rit',
    ),
  };
  SortBy sortBy = SortBy.date;
  SortOrder sortOrder = SortOrder.descending;

  @override
  Future<void> addNote(Note note) async {
    notesMap[notesMap.length] = note;
  }

  @override
  Future<void> deleteNote(Note note) async {
    var key = notesMap.values.toList().indexOf(note);
    while (key < notesMap.length - 1) {
      notesMap[key] = notesMap[key + 1]!;
      key += 1;
    }
    notesMap.remove(notesMap.length - 1);
  }

  @override
  Future<Map<int, Note>?> getNotes() async {
    return Map.from(notesMap);
  }

  @override
  Future<String> getSortByValue() async {
    return sortBy.name;
  }

  @override
  Future<String> getSortOrderValue() async {
    return sortOrder.name;
  }

  @override
  Future<void> updateNote(Note note) async {
    notesMap.update(
      notesMap.values.toList().indexOf(note),
      (oldNote) => note,
    );
  }

  @override
  Future<void> updateNotesOrder(Map<int, Note> notes) async {
    notes.forEach((key, note) {
      notes.update(key, (oldNote) => note);
    });
  }

  @override
  Future<void> updateSortByValue(String sortBy) async {
    sortBy = sortBy;
  }

  @override
  Future<void> updateSortOrderValue(String sortOrder) async {
    sortOrder = sortOrder;
  }
}
