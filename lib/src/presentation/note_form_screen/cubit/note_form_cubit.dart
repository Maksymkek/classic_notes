import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/dotted_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/numerated_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/sublist.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_text_controller.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/undo_controller/buffer_status.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
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

  late final NoteTextController _noteTextController;

  final NotePageCubit _notePageCubit;

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
        NoteTextController(this, controllerMap: state.note.controllerMap);
  }

  void onTextChanged(String newText) {
    _noteTextController.onTextChange();
  }

  void onMetadataButtonPressed(MetadataValue value, {Color? color}) {
    if (!_noteTextController.textCanBeStyled()) {
      return;
    }
    switch (value) {
      case MetadataValue.bold:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(fontWeight: FontWeight.bold),
          ),
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(fontWeight: FontWeight.normal),
          ),
        );
        break;
      case MetadataValue.italic:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(fontStyle: FontStyle.italic),
          ),
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(fontStyle: FontStyle.normal),
          ),
        );
        break;
      case MetadataValue.underline:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.underline),
          ),
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.none),
          ),
        );
        break;
      case MetadataValue.color:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(color: color ?? AppColors.black),
          ),
          CurrentMetadata(
            metadata:
                state.currentMetadata.metadata.copyWith(color: AppColors.black),
          ),
        );
        break;
      case MetadataValue.headerText:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: state.currentMetadata.metadata.copyWith(fontSize: 22),
          ),
          CurrentMetadata(
            metadata: state.currentMetadata.metadata.copyWith(fontSize: 18),
          ),
        );
        break;
      case MetadataValue.strikeThrough:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.strikeThrough),
          ),
          CurrentMetadata(
            metadata: state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.none),
          ),
        );
        break;
      case MetadataValue.baseText:
        _noteTextController.toggleStyle(
          CurrentMetadata(
            metadata: TextMetaDataStyles.baseText,
          ),
          CurrentMetadata(
            metadata: state.currentMetadata.metadata.copyWith(),
          ),
        );
        break;
    }
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
    final saveData = _noteTextController.prepareToSave(state.note);
    if (saveData.$1) {
      if (saveData.$2.id != -1) {
        _notePageCubit.onUpdateNoteClick(saveData.$2);
      } else {
        _notePageCubit.onAddNoteClick(saveData.$2);
      }
    }
  }
}
