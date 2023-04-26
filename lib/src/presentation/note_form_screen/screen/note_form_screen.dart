import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/note.dart';

class NoteFormScreenWidget extends StatelessWidget {
  const NoteFormScreenWidget({Key? key, required this.note}) : super(key: key);
  final Note note;
  static const screenName = 'note_form';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        height: 100,
        width: double.infinity,
        child: TextField(),
      ),
    );
  }
}
