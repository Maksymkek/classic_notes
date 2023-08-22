import 'dart:ui';

import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_input_controller.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// Represents current [TextMetadata] for [NoteInputController] and has additional
/// properties for [NoteFormCubit]
class CurrentMetadata {
  CurrentMetadata({
    required this.metadata,
    this.justToggled = true,
    this.canBeStyled = true,
  });

  /// If [TextMetadata] was just toggled to another
  bool justToggled;

  final TextMetadata metadata;

  /// Shows if the [TextMetadata] can be changed
  bool canBeStyled;

  /// Checks if given [MetadataValue] is active in [metadata]
  bool isMetaDataActive(MetadataValue metadataValue) {
    bool isActive = false;
    switch (metadataValue) {
      case MetadataValue.bold:
        isActive = metadata.fontWeight == FontWeight.bold;

      case MetadataValue.italic:
        isActive = metadata.fontStyle == FontStyle.italic;

      case MetadataValue.underline:
        isActive = metadata.decoration == TextDecorationEnum.underline;

      case MetadataValue.strikeThrough:
        isActive = metadata.decoration == TextDecorationEnum.strikeThrough;

      case MetadataValue.baseText:
        isActive = metadata == TextMetaDataStyles.baseText;
      case MetadataValue.headerText:
        isActive = metadata.fontSize == TextMetaDataStyles.headerText.fontSize;
      case MetadataValue.color:
        break;
    }
    return isActive;
  }
}
