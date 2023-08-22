import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/extensions/text_metadata_extension.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/base_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/text_offset/text_offset.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/title_controller/note_title.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/undo_controller/rich_undo_controller.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

part 'package:notes/src/presentation/note_form_screen/note_text_controller/note_text_controller.dart';

/// Powerful class which describes controller for rich text redactor
class NoteInputController extends NoteTextController with TitleController {
  NoteInputController(
    NoteFormCubit cubit, {
    Map<String, dynamic>? controllerMap,
  }) : super(cubit, controllerMap);

  @override
  void onTextChange() {
    int bufferLastCharIndex = _updateDeltas();
    titleWatcher();
    if (!bufferLastCharIndex.isNegative) {
      _undoController.updateBuffer(
        _controller.deltas[bufferLastCharIndex].char,
        _controller.deltas,
        _controller.text,
      );
    }
  }

  @override
  void addText(List<String> chars) {
    try {
      Future(() {
        for (var symbol in chars) {
          if (symbol.length != 1) {
            throw Exception([
              'In function $addText symbol in $chars had more than 1 length'
            ]);
          }
        }
      });
      final currentOffset = _controller.selection.baseOffset + chars.length;
      final baseOffset =
          _textOffset.getTrueOffset(_controller.selection.baseOffset);
      if (_needToAppend(baseOffset)) {
        _oldTextDeltas.addAll(
          chars.map(
            (char) => TextDelta(
              char: char,
              metadata: _cubit.state.currentMetadata.metadata,
            ),
          ),
        );
        String newText = _uniteInString(chars);
        _controller.text += newText;
      } else {
        _oldTextDeltas.insertAll(
          baseOffset,
          chars.map(
            (char) => TextDelta(
              char: char,
              metadata: _cubit.state.currentMetadata.metadata,
            ),
          ),
        );
        var charList = _controller.text.characters.toList();
        charList.insertAll(baseOffset, chars);
        String newText = _uniteInString(charList);
        _controller.text = newText;
        _controller.selection = TextSelection(
          baseOffset: currentOffset,
          extentOffset: currentOffset,
        );
      }
      _controller.setDeltas(_oldTextDeltas);
    } on Exception catch (ex) {
      FlutterLogs.logError(
        'Presentation',
        'NoteTextController',
        ex.toString(),
      );
    }
  }

  /// Toggles current [ListStatus] to another(or deactivates if current is active)
  void toggleList(ListInput listInput) {
    if (!_textCanBeStyled()) {
      return;
    }
    if (_cubit.state.listStatus == listInput.listStatus) {
      _listInput = null;
      _cubit.copyWith(listStatus: ListStatus.none);
    } else {
      _listInput = listInput;
      _cubit.copyWith(listStatus: listInput.listStatus);
    }
  }

  /// Toggles [CurrentMetadata] with transmitted arguments
  void toggleMetadata(MetadataValue value, {Color? color}) {
    if (!_textCanBeStyled()) {
      return;
    }
    switch (value) {
      case MetadataValue.bold:
        _toggleStyle(
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(fontWeight: FontWeight.bold),
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(fontWeight: FontWeight.normal),
          ),
        );
        break;
      case MetadataValue.italic:
        _toggleStyle(
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(fontStyle: FontStyle.italic),
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(fontStyle: FontStyle.normal),
          ),
        );
        break;
      case MetadataValue.underline:
        _toggleStyle(
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.underline),
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.none),
          ),
        );
        break;
      case MetadataValue.color:
        _toggleStyle(
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(color: color ?? AppColors.black),
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(color: AppColors.black),
          ),
        );
        break;
      case MetadataValue.headerText:
        _toggleStyle(
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(fontSize: TextMetaDataStyles.headerText.fontSize),
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(fontSize: TextMetaDataStyles.baseText.fontSize),
          ),
        );
        break;
      case MetadataValue.strikeThrough:
        _toggleStyle(
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.strikeThrough),
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata
                .copyWith(decoration: TextDecorationEnum.none),
          ),
        );
        break;
      case MetadataValue.baseText:
        _toggleStyle(
          CurrentMetadata(
            metadata: TextMetaDataStyles.baseText,
          ),
          CurrentMetadata(
            metadata: _cubit.state.currentMetadata.metadata.copyWith(),
          ),
        );
        break;
    }
  }

  /// Need to call for save. Returns whether the note have been saved
  bool save(Note note, Function(Note) saveFunction) {
    if (_undoController.bufferIterator == 0 || controller.text.isEmpty) {
      return false;
    }
    var endOfTitle = _controller.text.indexOf('\n');
    final Note newNote;
    if (endOfTitle != -1) {
      newNote = note.copyWith(
        title: _controller.text.substring(0, endOfTitle),
        text: _controller.text.substring(endOfTitle),
        dateOfLastChange: DateTime.now(),
      );
    } else {
      newNote = note.copyWith(title: _controller.text, text: '');
    }
    newNote.controllerMap = _controller.toMap();
    saveFunction(newNote);
    return true;
  }

  ///Moves backward in history of changes
  Future<void> undo() async {
    final undoResult = await _undoController.undo();
    if (undoResult != null) {
      _setControllerDeltas(undoResult.deltas, undoResult.text);
    }
  }

  ///Moves forward in history of changes
  Future<void> redo() async {
    final redoResult = await _undoController.redo();
    if (redoResult != null) {
      _setControllerDeltas(redoResult.deltas, redoResult.text);
    }
  }
}
