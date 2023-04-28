import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_text_controller.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

///stores buffered data from [NoteTextController] needed in [RichUndoController]
class RichUndoModel {
  RichUndoModel(
    this.deltas,
    this.text,
  );

  final List<TextDelta> deltas;
  final String text;
}
