import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/undo_controller/buffer_status.dart';

class NoteForm {
  NoteForm({
    required this.note,
    required this.currentMetadata,
    required this.bufferStatus,
    this.listStatus = ListStatus.none,
  });

  final Note note;
  final BufferStatus bufferStatus;
  final ListStatus listStatus;
  final CurrentMetadata currentMetadata;
}
