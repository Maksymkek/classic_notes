import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';

class NoteFormCubit extends Cubit<NoteForm> {
  NoteFormCubit(super.initialState);

  void _copyWith(
    TextEditingController? controller,
    Note? note,
    List<String>? buffer,
    int? bufferPosition,
  ) {
    emit(
      NoteForm(
        controller: controller ?? state.controller,
        note: note ?? state.note,
        buffer: buffer ?? state.buffer,
        currentBuffer: bufferPosition ?? state.currentBuffer,
      ),
    );
  }

  void onTitleSetted(String title) {}

  void onTextChanged(String newText) {}
}
