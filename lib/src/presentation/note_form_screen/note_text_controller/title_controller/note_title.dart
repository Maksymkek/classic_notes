import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/text_offset/text_offset.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// checks title changing.
class NoteTitle {
  NoteTitle(
    this._controller,
    this._cubit,
    this._oldTextDeltas,
    this._textOffset,
    this._noteTitle,
  );

  final RichTextEditorController _controller;
  List<TextDelta> _oldTextDeltas;
  set oldTextDelta(List<TextDelta> value) => _oldTextDeltas = value;
  final TextOffset _textOffset;
  final NoteFormCubit _cubit;
  List<TextDelta>? _noteTitle;

  /// method that checks title changes and separate title from text.
  ///
  /// (need to use when text changed in controller)
  void titleWatcher() {
    int endOfTitle = _getIndexOfDelta('\n');
    var deltasLength = _controller.deltas.length;
    if (deltasLength == 0) {
      return;
    }
    if (endOfTitle == -1) {
      _noteTitle = null;
      if (_cubit.state.currentMetadata.metadata !=
          TextMetaDataStyles.mainHeaderText) {
        _cubit.copyWith(
          currentMetadata: CurrentMetadata(
            metadata: TextMetaDataStyles.mainHeaderText,
            justToggled: true,
          ),
        );
      }
      for (int i = 0; i < deltasLength; i++) {
        if (_controller.deltas[i].metadata !=
            TextMetaDataStyles.mainHeaderText) {
          _controller.deltas[i] = _oldTextDeltas[i] = _controller.deltas[i]
              .copyWith(metadata: TextMetaDataStyles.mainHeaderText);
        }
      }
    } else if (_titleNotChanged()) {
      return;
    } else {
      if (endOfTitle != deltasLength) {
        for (int i = 0; i < deltasLength; i++) {
          if (i < endOfTitle) {
            if (_controller.deltas[i].metadata !=
                TextMetaDataStyles.mainHeaderText) {
              _controller.deltas[i] = _oldTextDeltas[i] = _controller.deltas[i]
                  .copyWith(metadata: TextMetaDataStyles.mainHeaderText);
            }
          } else {
            if (_controller.deltas[i].metadata ==
                TextMetaDataStyles.mainHeaderText) {
              _controller.deltas[i] = _oldTextDeltas[i] = _controller.deltas[i]
                  .copyWith(metadata: TextMetaDataStyles.baseText);
            }
          }
        }
      }
      _noteTitle = _controller.deltas.getRange(0, endOfTitle + 1).toList();
      if (_needToggleMetadata(endOfTitle)) {
        _cubit.copyWith(
          currentMetadata: CurrentMetadata(
            metadata: TextMetaDataStyles.baseText,
            justToggled: true,
          ),
        );
      }
    }
  }

  /// whether to switch to [TextMetaDataStyles.baseText] (if we are not inside the heading)
  bool _needToggleMetadata(int endOfTitle) {
    var rawBaseOffset = _controller.selection.baseOffset;
    int currentOffset = _textOffset.getTrueOffset(rawBaseOffset);
    return _cubit.state.currentMetadata.metadata !=
            TextMetaDataStyles.baseText &&
        endOfTitle == currentOffset - 1;
  }

  /// return index of [TextDelta] in [_controller.deltas] with given char
  int _getIndexOfDelta(String char) {
    for (int i = 0; i < _controller.deltas.length; i++) {
      if (_controller.deltas[i].char == char) {
        return i;
      }
    }
    return -1;
  }

  bool _titleNotChanged() => _noteTitle != null && _checkTitle();

  /// checks if the title has changed
  bool _checkTitle() {
    for (int i = 0; i < _noteTitle!.length; i++) {
      if (_noteTitle?[i].char != _controller.deltas[i].char) {
        return false;
      }
    }
    return true;
  }
}
