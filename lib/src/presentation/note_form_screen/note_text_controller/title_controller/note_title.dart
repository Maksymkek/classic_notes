import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_model.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_input_controller.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// Checks title changing and gives [TextMetaDataStyles.mainHeaderText] metadata to it
mixin TitleController on NoteTextController {
  List<TextDelta>? _noteTitle;

  /// Method that checks title changes and separate title from text.
  ///
  /// (need to use when text changed in controller)
  void titleWatcher() {
    int endOfTitle = _getIndexOfDelta('\n');
    var deltasLength = controller.deltas.length;
    if (deltasLength == 0) {
      return;
    }
    if (endOfTitle == -1) {
      _noteTitle = null;
      if (cubit.state.currentMetadata.metadata !=
          TextMetaDataStyles.mainHeaderText) {
        cubit.copyWith(
          currentMetadata: CurrentMetadata(
            metadata: TextMetaDataStyles.mainHeaderText,
            justToggled: true,
          ),
        );
      }
      for (int i = 0; i < deltasLength; i++) {
        if (controller.deltas[i].metadata !=
            TextMetaDataStyles.mainHeaderText) {
          controller.deltas[i] = oldTextDeltas()[i] = controller.deltas[i]
              .copyWith(metadata: TextMetaDataStyles.mainHeaderText);
        }
      }
    } else if (_titleNotChanged()) {
      return;
    } else {
      if (endOfTitle != deltasLength) {
        for (int i = 0; i < deltasLength; i++) {
          if (i < endOfTitle) {
            if (controller.deltas[i].metadata !=
                TextMetaDataStyles.mainHeaderText) {
              controller.deltas[i] = oldTextDeltas()[i] = controller.deltas[i]
                  .copyWith(metadata: TextMetaDataStyles.mainHeaderText);
            }
          } else {
            if (controller.deltas[i].metadata ==
                TextMetaDataStyles.mainHeaderText) {
              controller.deltas[i] = oldTextDeltas()[i] = controller.deltas[i]
                  .copyWith(metadata: TextMetaDataStyles.baseText);
            }
          }
        }
      }
      _noteTitle = controller.deltas.getRange(0, endOfTitle + 1).toList();
      if (_needToggleMetadata(endOfTitle)) {
        cubit.copyWith(
          currentMetadata: CurrentMetadata(
            metadata: TextMetaDataStyles.baseText,
            justToggled: true,
          ),
        );
      }
    }
  }

  /// Whether to switch to [TextMetaDataStyles.baseText] (if we are not inside the heading)
  bool _needToggleMetadata(int endOfTitle) {
    var rawBaseOffset = controller.selection.baseOffset;
    int currentOffset = textOffset.getTrueOffset(rawBaseOffset);
    return cubit.state.currentMetadata.metadata !=
            TextMetaDataStyles.baseText &&
        endOfTitle == currentOffset - 1;
  }

  /// Return index of [TextDelta] in [_controller.deltas] with given char
  int _getIndexOfDelta(String char) {
    for (int i = 0; i < controller.deltas.length; i++) {
      if (controller.deltas[i].char == char) {
        return i;
      }
    }
    return -1;
  }

  bool _titleNotChanged() => _noteTitle != null && _checkTitle();

  /// Checks if the title has changed
  bool _checkTitle() {
    for (int i = 0; i < _noteTitle!.length; i++) {
      if (_noteTitle?[i].char != controller.deltas[i].char) {
        return false;
      }
    }
    return true;
  }
}
