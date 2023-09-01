import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/interfaces/screen_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/dotted_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/numerated_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/sublist.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_input_controller.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/undo_controller/buffer_status.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

class NoteFormCubit extends Cubit<NoteForm> {
  NoteFormCubit(Note note, this._notePageCubit)
      : super(
          NoteForm(
            note: note,
            bufferStatus: BufferStatus(),
            currentMetadata:
                CurrentMetadata(metadata: TextMetaDataStyles.baseText),
          ),
        );

  late final NoteInputController _noteTextController;

  final NoteScreenCubit _notePageCubit;

  RichTextEditorController get controller => _noteTextController.controller;

  void copyWith({
    Note? note,
    BufferStatus? bufferStatus,
    CurrentMetadata? currentMetadata,
    ListStatus? listStatus,
  }) {
    emit(
      NoteForm(
        note: note ?? state.note,
        bufferStatus: bufferStatus ?? state.bufferStatus,
        currentMetadata: currentMetadata ?? state.currentMetadata,
        listStatus: listStatus ?? state.listStatus,
      ),
    );
  }

  Future<void> onScreenLoad() async {
    _noteTextController =
        NoteInputController(this, controllerMap: state.note.controllerMap);
  }

  void onTextChanged(String newText) {
    _noteTextController.onTextChange();
  }

  void onMetadataButtonPressed(MetadataValue value, {Color? color}) {
    _noteTextController.toggleMetadata(value, color: color);
  }

  bool onIndentClicked() {
    _noteTextController.addText(['\u2002']);
    return true;
  }

  void onDotListClicked() {
    _noteTextController.toggleList(DottedList());
  }

  void onNumListClicked() {
    _noteTextController.toggleList(NumList());
  }

  void onSubListClicked() {
    _noteTextController.toggleList(SubList());
  }

  Future<void> onUndoClicked() {
    return _noteTextController.undo();
  }

  Future<void> onRedoClicked() {
    return _noteTextController.redo();
  }

  void saveNote() {
    _noteTextController.save(
      state.note,
      state.note.id == -1
          ? _notePageCubit.onAddNoteClick
          : _notePageCubit.onUpdateNoteClick,
    );
  }
}
