import 'package:notes/src/domain/entity/item/item_settings_model.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/interfaces/screen_state.dart';

class NotePageState extends ScreenState<Note> {
  NotePageState({
    required ItemSettingsModel settings,
    required Map<int, Note> notes,
  }) : super(notes, settings);
}
