import 'package:flutter/cupertino.dart';
import 'package:notes/src/domain/entity/note.dart';

class NoteForm {
  NoteForm({
    required this.controller,
    required this.note,
    required this.buffer,
    required this.currentBuffer,
  });

  final Note note;
  final TextEditingController controller;
  final List<String> buffer;
  final int currentBuffer;
}
