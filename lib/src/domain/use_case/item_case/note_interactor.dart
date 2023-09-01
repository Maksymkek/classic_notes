import 'package:flutter/foundation.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/domain/use_case/item_case/item_interactor.dart';

base class NoteInteractor extends ItemInteractor<Note> {
  NoteInteractor(super.itemRepository, this.updateFolder);

  final VoidCallback updateFolder;
}
