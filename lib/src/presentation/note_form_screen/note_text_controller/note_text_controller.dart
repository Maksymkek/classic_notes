// ignore_for_file: invalid_use_of_protected_member

part of 'package:notes/src/presentation/note_form_screen/note_text_controller/note_input_controller.dart';

/// Manages rich text control
abstract class NoteTextController {
  NoteTextController(this._cubit, Map<String, dynamic>? controllerMap) {
    _initController(controllerMap);
    _textOffset = TextOffset(_controller, oldTextDeltas, _cubit);
    _textOffset.oldBaseSelectionOffset = _controller.deltas.length;
    _undoController = RichUndoController(_controller, _cubit);
    _setCursorListener();
  }

  final NoteFormCubit _cubit;

  @protected
  NoteFormCubit get cubit => _cubit;

  /// Needed to detect bugs in the deltas
  List<TextDelta> _oldTextDeltas = [];

  @protected
  List<TextDelta> oldTextDeltas() => _oldTextDeltas;

  late final RichTextEditorController _controller;

  RichTextEditorController get controller => _controller;

  late final TextOffset _textOffset;

  @protected
  TextOffset get textOffset => _textOffset;

  late final RichUndoController _undoController;

  /// Needed to store class descendants instances
  ListInput? _listInput;

  /// Need to call when user changed text
  void onTextChange();

  /// Add symbols to controller
  ///
  /// WARNING: Length of the symbol in [chars] mustn't be bigger than 1. Only one symbol in the String
  void addText(List<String> chars);

  /// Initializes [_controller]
  void _initController(Map<String, dynamic>? controllerMap) {
    if (controllerMap != null) {
      _controller = RichTextEditorController.fromMap(controllerMap);
      _oldTextDeltas = List.from(_controller.deltas);
    } else {
      _controller = RichTextEditorController()
        ..metadata = TextMetaDataStyles.mainHeaderText;
    }
  }

  /// Add listener to the [_controller] for the [_textOffset] detection
  void _setCursorListener() {
    _controller.addListener(() {
      if (_cursorMoved()) {
        if (_controller.selection.isCollapsed) {
          _textOffset.onSelection();
        } else {
          _textOffset.onRangeSelected();
        }
      }
    });
  }

  bool _cursorMoved() {
    return _controller.selection.baseOffset !=
            _textOffset.oldBaseSelectionOffset &&
        _oldTextDeltas.length == _controller.deltas.length;
  }

  /// Corrects and adds styles for new text
  int _updateDeltas() {
    final baseOffset = _controller.selection.baseOffset;
    bool textAdded = false;
    bool textDeleted = false;
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
    } else if (_oldTextDeltas.length > _controller.deltas.length) {
      textDeleted = true;
    } else if (_oldTextDeltas.length <= _controller.deltas.length) {
      textAdded = true;
    }
    _textOffset.oldBaseSelectionOffset = _controller.selection.baseOffset;
    if (textDeleted) {
      return _updateDeletedDeltas(baseOffset);
    }
    if (textAdded) {
      return _updateAddedDeltas(baseOffset);
    }
    return -1;
  }

  /// Corrects and adds styles if user added text
  int _updateAddedDeltas(int baseOffset) {
    baseOffset = _textOffset.getTrueOffset(baseOffset);
    final addedTextLength = _controller.deltas.length - _oldTextDeltas.length;
    final startIndex = baseOffset - addedTextLength;
    final endIndex = baseOffset - 1;
    try {
      final startRangeDelta = _controller.deltas[startIndex];
      if (_needToggleMetadata(startRangeDelta)) {
        for (int i = startIndex; i <= endIndex; i++) {
          final delta = TextDelta(
            char: _controller.deltas[i].char,
            metadata: _cubit.state.currentMetadata.metadata,
          );
          _controller.deltas[i] = delta;
          _oldTextDeltas.insert(i, delta.copyWith());
        }
        _cubit.state.currentMetadata.justToggled = false;
      } else {
        for (int i = startIndex; i <= endIndex; i++) {
          var prevSymbolIndex = startIndex - 1;
          final TextMetadata metadata = prevSymbolIndex < 0
              ? TextMetaDataStyles.mainHeaderText
              : _controller.deltas[prevSymbolIndex].metadata!;

          final delta = TextDelta(
            char: _controller.deltas[i].char,
            metadata: metadata,
          );
          _controller.deltas[i] = delta;
          _oldTextDeltas.insert(i, delta.copyWith());
        }
      }
    } catch (_) {}

    if (addedTextLength > 1) _fixBuggedDeltas();
    if (_controller.deltas[endIndex].char == '\n') {
      _listWatcher();
    }
    return endIndex;
  }

  /// Corrects and adds styles if user deleted text
  int _updateDeletedDeltas(int baseOffset) {
    baseOffset = _textOffset.getTrueOffset(baseOffset);
    final deletedRange = _oldTextDeltas.length - _controller.deltas.length;
    final endOffset = deletedRange + baseOffset;
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
    if (deletedRange > 1) _fixBuggedDeltas();
    return baseOffset - 1;
  }

  /// Return whether need to grab metadata from previous symbol or
  /// toggle it. Used in [_updateAddedDeltas]
  bool _needToggleMetadata(TextDelta startRangeCharDelta) {
    return _cubit.state.currentMetadata.metadata !=
            startRangeCharDelta.metadata &&
        _cubit.state.currentMetadata.justToggled;
  }

  /// Needed to fix styles of the controller deltas
  void _fixBuggedDeltas() {
    for (int i = 0; i < _oldTextDeltas.length; i++) {
      final newDelta = _controller.deltas[i];
      final oldDelta = _oldTextDeltas[i];
      if (oldDelta.metadata != newDelta.metadata) {
        _controller.deltas[i] = oldDelta.copyWith(char: newDelta.char);
      }
      if (oldDelta.char != newDelta.char) {
        _oldTextDeltas[i] = oldDelta.copyWith(char: newDelta.char);
      }
    }
  }

  /// Returns whether text can be styled
  bool _textCanBeStyled() {
    if (_controller.deltas.isEmpty) {
      return false;
    } else {
      final trueOffset =
          _textOffset.getTrueOffset(_controller.selection.baseOffset - 1);
      if (trueOffset < 1) {
        return false;
      }
      var selectedDelta = _controller.deltas[trueOffset];
      if (selectedDelta.metadata == TextMetaDataStyles.mainHeaderText) {
        return false;
      }
      return true;
    }
  }

  /// Toggles text style
  ///
  /// Parameters:
  ///
  ///[toggled] - will be used if current metadata is not equal to it
  ///
  /// [untoggled] - will be used if current metadata is [toggled]
  void _toggleStyle(CurrentMetadata toggled, CurrentMetadata untoggled) {
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

  /// Toggles selected range style
  void _toggleRangeStyle(CurrentMetadata toggled, CurrentMetadata untoggled) {
    final baseOffset =
        _textOffset.getTrueOffset(_controller.selection.baseOffset);
    final extentOffset =
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
    // ignore: invalid_use_of_visible_for_testing_member
    _controller.notifyListeners();
    _undoController.updateBuffer(
      ' ',
      _controller.deltas,
      _controller.text,
    );
  }

  bool get _rangeIsSelected => !_controller.selection.isCollapsed;

  ///UnitTest [List] of symbols in [String]
  String _uniteInString(List<String> symbolsToAdd) {
    String newText = '';
    for (final char in symbolsToAdd) {
      newText += char;
    }
    return newText;
  }

  bool _needToAppend(int baseOffset) {
    return baseOffset == _controller.text.length || _controller.deltas.isEmpty;
  }

  /// If [ListStatus] from state is not null adds the list separator in text
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

  /// Sets new deltas to controller
  void _setControllerDeltas(List<TextDelta> deltas, String text) {
    _controller.setDeltas(deltas);
    _oldTextDeltas = List.from(deltas);

    _controller.text = text;
  }
}
