import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/extensions/text_metadata_extension.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/base_list.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/list_controller/list_status.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/text_offset/text_offset.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/title_controller/note_title.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/undo_controller/rich_undo_controller.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// powerful class which describes controller for rich text redactor
class NoteTextController {
  NoteTextController(this._cubit, {Map<String, dynamic>? controllerMap}) {
    if (controllerMap != null) {
      _controller = RichTextEditorController.fromMap(controllerMap);
      _oldTextDeltas = List.from(_controller.deltas);
    } else {
      _controller = RichTextEditorController();
    }

    //--------------------------
    _textOffset = TextOffset(_controller, _oldTextDeltas, _cubit);
    _textOffset.oldBaseSelectionOffset = _controller.deltas.length;
    _undoController = RichUndoController(_controller, _cubit);
    _setCursorListener();
    _noteTitle =
        NoteTitle(_controller, _cubit, _oldTextDeltas, _textOffset, null);
  }

  /// add listener to the [_controller] for the [_textOffset] detection
  void _setCursorListener() {
    _controller.addListener(() {
      if (_controller.selection.baseOffset !=
              _textOffset.oldBaseSelectionOffset &&
          _oldTextDeltas.length == _controller.deltas.length) {
        if (_controller.selection.isCollapsed) {
          _textOffset.onSelection();
        } else {
          _textOffset.onRangeSelected();
        }
      }
    });
  }

//-------------------------------------------------------------------------------
  final NoteFormCubit _cubit;

  late final TextOffset _textOffset;

  late final NoteTitle _noteTitle;

  late final RichUndoController _undoController;

  late final RichTextEditorController _controller;

  RichTextEditorController get controller => _controller;

  /// needed to detect bugs in the package
  List<TextDelta> _oldTextDeltas = [];

  /// needed to store class descendants instances
  ListInput? _listInput;

//-------------------------------------------------------------------------------

  /// need to call when user changed text
  void onTextChange() {
    int bufferLastCharIndex = _updateDeltas();
    _noteTitle.titleWatcher();
    if (!bufferLastCharIndex.isNegative) {
      _undoController.updateBuffer(
        _controller.deltas[bufferLastCharIndex].char,
        _controller.deltas,
        _controller.text,
      );
    }
  }

  /// corrects styles for new text
  int _updateDeltas() {
    var baseOffset = _controller.selection.baseOffset;
    //для избежания повторов
    bool textAdded = false;
    bool textDeleted = false;
    // проверка на то что символ один
    if (_controller.deltas.length <= 1) {
      _oldTextDeltas.clear();
      if (_controller.deltas.length == 1) {
        _oldTextDeltas.add(
          TextDelta(
            char: _controller.deltas[0].char,
            metadata: TextMetaDataStyles.mainHeaderText,
          ),
        );
        return 0;
      } else {
        return -1;
      }
    }
    // проверка на удаление символов
    else if (_oldTextDeltas.length > _controller.deltas.length) {
      textDeleted = true;
    } else if (_oldTextDeltas.length <= _controller.deltas.length) {
      textAdded = true;
    }
    _textOffset.oldBaseSelectionOffset = _controller.selection.baseOffset;
    //удаление текста
    if (textDeleted) {
      return _updateDeletedDeltas(baseOffset);
    }
    if (textAdded) {
      return _updateAddedDeltas(baseOffset);
    }
    return -1;
  }

  /// corrects styles if user added text
  int _updateAddedDeltas(int baseOffset) {
    baseOffset = _textOffset.getTrueOffset(baseOffset);
    var addedTextLength = _controller.deltas.length - _oldTextDeltas.length;
    var startIndex = baseOffset - addedTextLength;
    var endIndex = baseOffset - 1;
    try {
      var startRangeDelta = _controller.deltas[startIndex];
      if (_needToggleMetadata(startRangeDelta)) {
        for (int i = startIndex; i <= endIndex; i++) {
          var delta = TextDelta(
            char: _controller.deltas[i].char,
            metadata: _cubit.state.currentMetadata.metadata,
          );
          _controller.deltas[i] = delta;
          _oldTextDeltas.insert(i, delta.copyWith());
        }
        _cubit.state.currentMetadata.justToggled = false;
      } else {
        for (int i = startIndex; i <= endIndex; i++) {
          var prevSymbol = startIndex - 1;
          var delta = TextDelta(
            char: _controller.deltas[i].char,
            metadata: _controller.deltas[prevSymbol].metadata,
          );
          _controller.deltas[i] = delta;
          _oldTextDeltas.insert(i, delta.copyWith());
        }
      }
    } catch (_) {}
    _fixBuggedDeltas();
    if (_controller.deltas[endIndex].char == '\n') {
      _listWatcher();
    }
    return endIndex;
  }

  /// corrects styles if user deleted text
  int _updateDeletedDeltas(int baseOffset) {
    baseOffset = _textOffset.getTrueOffset(baseOffset);
    int deletedRange = _oldTextDeltas.length - _controller.deltas.length;
    int endOffset = deletedRange + baseOffset;
    if (_textOffset.replacedByEmoji) {
      _oldTextDeltas[baseOffset - 1] = _controller.deltas[baseOffset - 1];
    }
    final currentMetadata = _controller.deltas[baseOffset - 1].metadata;
    if (currentMetadata != _cubit.state.currentMetadata.metadata) {
      _cubit.copyWith(
        currentMetadata: CurrentMetadata(
          metadata: currentMetadata ?? _cubit.state.currentMetadata.metadata,
        ),
      );
    }
    _oldTextDeltas.removeRange(baseOffset, endOffset);

    _fixBuggedDeltas();
    return baseOffset - 1;
  }

  /// return whether need to grab metadata from previous symbol or
  /// toggle it. Used in [_updateAddedDeltas]
  bool _needToggleMetadata(TextDelta startRangeCharDelta) {
    return _cubit.state.currentMetadata.metadata !=
            startRangeCharDelta.metadata &&
        _cubit.state.currentMetadata.justToggled;
  }

  /// needed to fix styles of the controller deltas
  void _fixBuggedDeltas() {
    for (int i = 0; i < _oldTextDeltas.length; i++) {
      var newDelta = _controller.deltas[i];
      var oldDelta = _oldTextDeltas[i];
      if (oldDelta.metadata != newDelta.metadata) {
        _controller.deltas[i] = oldDelta.copyWith(char: newDelta.char);
      }
      if (oldDelta.char != newDelta.char) {
        _oldTextDeltas[i] = oldDelta.copyWith(char: newDelta.char);
      }
    }
  }

  /// returns whether text can be styled
  bool textCanBeStyled() {
    if (_controller.deltas.isEmpty) {
      return false;
    } else {
      var trueOffset =
          _textOffset.getTrueOffset(_controller.selection.baseOffset - 1);
      if (trueOffset < 1) {
        return false;
      }
      var selectedDelta = _controller.deltas[trueOffset - 1].metadata;
      if (selectedDelta == TextMetaDataStyles.mainHeaderText) {
        return false;
      }
      return true;
    }
  }

  /// toggles text style
  ///
  /// Parameters:
  ///
  ///[toggled] - will be used if current metadata is not equal to it
  ///
  /// [untoggled] - will be used if current metadata is [toggled]
  void toggleStyle(CurrentMetadata toggled, CurrentMetadata untoggled) {
    if (_rangeIsSelected) {
      _toggleRangeStyle(toggled, untoggled);
      return;
    }
    if (_cubit.state.currentMetadata.metadata == toggled.metadata) {
      _cubit.copyWith(
        currentMetadata: CurrentMetadata(
          metadata: untoggled.metadata,
        ),
      );
    } else {
      _cubit.copyWith(
        currentMetadata: CurrentMetadata(
          metadata: toggled.metadata,
        ),
      );
    }
  }

  /// toggles selected range style
  void _toggleRangeStyle(CurrentMetadata toggled, CurrentMetadata untoggled) {
    var baseOffset =
        _textOffset.getTrueOffset(_controller.selection.baseOffset);
    var extentOffset =
        _textOffset.getTrueOffset(_controller.selection.extentOffset);

    for (int i = baseOffset; i < extentOffset; i += 1) {
      if (_controller.deltas[extentOffset - 1].metadata!
          .isEqualTo(toggled.metadata)) {
        _controller.deltas[i] =
            _oldTextDeltas[i] = _controller.deltas[i].copyWith(
          metadata: untoggled.metadata,
        );
      } else {
        _controller.deltas[i] =
            _oldTextDeltas[i] = _controller.deltas[i].copyWith(
          metadata: toggled.metadata,
        );
      }
    }
    _cubit.copyWith(
      currentMetadata: CurrentMetadata(
        metadata: _controller.deltas[extentOffset - 1].metadata!,
      ),
    );
    //cubit.state.controller.toggleSuperscript();
    _controller.notifyListeners();
    //cubit.state.controller.applyMetadataToTextInSelection(newMetadata: newMetadata, deltas: deltas, change: change, selection: selection);
    _undoController.updateBuffer(
      ' ',
      _controller.deltas,
      _controller.text,
    );
  }

  bool get _rangeIsSelected => !_controller.selection.isCollapsed;

  /// add symbols to controller
  ///
  /// WARNING: Length of the symbol in [symbols] mustn't be bigger than 1. Only one symbol in the String
  void addText(List<String> symbols) {
    try {
      Future(() {
        for (var symbol in symbols) {
          if (symbol.length != 1) {
            throw Exception([
              'In function $addText symbol in $symbols had more than 1 length'
            ]);
          }
        }
      });
      final currentOffset = _controller.selection.baseOffset + symbols.length;
      final baseOffset =
          _textOffset.getTrueOffset(_controller.selection.baseOffset);
      if (needToAppend(baseOffset)) {
        _oldTextDeltas.addAll(
          symbols.map(
            (char) => TextDelta(
              char: char,
              metadata: _cubit.state.currentMetadata.metadata,
            ),
          ),
        );
        String newText = _uniteInString(symbols);
        _controller.text += newText;
      } else {
        _oldTextDeltas.insertAll(
          baseOffset,
          symbols.map(
            (char) => TextDelta(
              char: char,
              metadata: _cubit.state.currentMetadata.metadata,
            ),
          ),
        );
        var charList = _controller.text.characters.toList();
        charList.insertAll(baseOffset, symbols);
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

  String _uniteInString(List<String> symbolsToAdd) {
    String newText = '';
    for (final char in symbolsToAdd) {
      newText += char;
    }
    return newText;
  }

  bool needToAppend(int baseOffset) {
    return baseOffset == _controller.text.length || _controller.deltas.isEmpty;
  }

  void _listWatcher() {
    if (_cubit.state.listStatus != ListStatus.none) {
      List<String> separator = _listInput?.getSeparator(
            _controller.text,
            _textOffset.getTrueOffset(_controller.selection.baseOffset),
          ) ??
          [];
      addText(separator);
    }
  }

  void toggleList(ListInput listInput) {
    if (!textCanBeStyled()) {
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

  void _setControllerDeltas(List<TextDelta> deltas, String text) {
    _controller.setDeltas(deltas);
    _oldTextDeltas = List.from(deltas);
    _noteTitle.oldTextDelta = _textOffset.oldTextDelta = _oldTextDeltas;
    _controller.text = text;
  }

  void undo() {
    final undoResult = _undoController.undo();
    if (undoResult != null) {
      _setControllerDeltas(undoResult.deltas, undoResult.text);
    }
  }

  void redo() {
    final redoResult = _undoController.redo();
    if (redoResult != null) {
      _setControllerDeltas(redoResult.deltas, redoResult.text);
    }
  }

  bool save(Note note) {
    if (_undoController.bufferIterator == 0) {
      return false;
    }
    var endOfTitle = _controller.text.indexOf('\n');
    if (endOfTitle != -1) {
      note.title = _controller.text.substring(0, endOfTitle);
      note.text = _controller.text.substring(endOfTitle);
      note.dateOfLastChange = DateTime.now();
    } else {
      note.title = _controller.text;
    }
    note.controllerMap = _controller.toMap();
    return true;
  }
}
