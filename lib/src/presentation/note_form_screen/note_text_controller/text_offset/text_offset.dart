import 'dart:typed_data';

import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

class TextOffset {
  TextOffset(this._controller, this._oldTextDeltas, this._cubit);

  List<TextDelta> _oldTextDeltas;
  set oldTextDelta(List<TextDelta> value) => _oldTextDeltas = value;
  final NoteFormCubit _cubit;
  final RichTextEditorController _controller;

  /// amount of 2 bytes symbol in previous enter
  int _prev2BytesAmount = 0;

  /// previous enter baseOffset
  int oldBaseSelectionOffset = 0;

  /// whether text where replaced by emoji
  bool _emojiReplacement = false;

  bool get replacedByEmoji => _emojiReplacement;

  int get prevSpecialSymbolsAmount => _prev2BytesAmount;

  /// Invokes when cursor location is changed without text changes
  void onSelection() {
    oldBaseSelectionOffset = _controller.selection.baseOffset;
    _cubit.state.currentMetadata.justToggled = false;
    if (oldBaseSelectionOffset == -1) {
      return;
    }
    if (_controller.deltas.isNotEmpty) {
      var baseOffset = getTrueOffset(_controller.selection.baseOffset);
      _cubit.copyWith(
        currentMetadata: CurrentMetadata(
          metadata: _oldTextDeltas[baseOffset - 1].metadata ??
              TextMetaDataStyles.baseText,
        ),
      );
    } else {
      _cubit.copyWith(
        currentMetadata: CurrentMetadata(
          metadata: TextMetaDataStyles.mainHeaderText,
        ),
      );
    }
  }

  /// Invokes when text range is selected
  void onRangeSelected() {
    oldBaseSelectionOffset = _controller.selection.baseOffset;
    var baseOffset = getTrueOffset(_controller.selection.baseOffset);
    _cubit.copyWith(
      currentMetadata: CurrentMetadata(
        metadata: _controller.deltas[baseOffset].metadata ??
            TextMetaDataStyles.baseText,
      ),
    );
  }

  /// Needed to get index in array from [baseOffset].
  ///
  /// Description:
  ///
  /// Detects 2 bytes symbols and also checks whether word were replaced by emoji
  int getTrueOffset(int baseOffset) {
    int current2BytesAmount = 0;
    for (int i = 0; i < _controller.deltas.length; i += 1) {
      var textDelta = _controller.deltas[i];
      var offset = Uint16List.fromList(textDelta.char.codeUnits).length;
      if (baseOffset <= i) {
        break;
      }
      if (offset > 1) {
        baseOffset = baseOffset - (offset - 1);
        current2BytesAmount += 1;
      }
    }
    if (current2BytesAmount > _prev2BytesAmount) {
      _prev2BytesAmount = current2BytesAmount;
      _emojiReplacement = true;
    }
    if (baseOffset == 0) {
      baseOffset += 1;
    }
    return baseOffset;
  }
}
