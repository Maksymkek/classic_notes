import 'dart:ui';

import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/note_text_controller.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

/// represents current [TextMetadata] for [NoteTextController] and has additional
/// properties for [NoteFormCubit]
class CurrentMetadata {
  CurrentMetadata({
    required this.metadata,
    this.justToggled = true,
    this.canBeStyled = true,
  });

  /// if [TextMetadata] was just toggled to another
  bool justToggled;

  final TextMetadata metadata;

  /// shows if the [TextMetadata] can be changed
  bool canBeStyled;

  /// checks if given [MetadataValue] is active in [metadata]
  bool isMetaDataActive(MetadataValue metadataValue) {
    bool isActive = false;
    switch (metadataValue) {
      // ignore: missing_enum_constant_in_switch
      case MetadataValue.bold:
        isActive = metadata.fontWeight == FontWeight.bold;
        break;
      case MetadataValue.italic:
        isActive = metadata.fontStyle == FontStyle.italic;
        break;
      case MetadataValue.underline:
        isActive = metadata.decoration == TextDecorationEnum.underline;
        break;
      case MetadataValue.strikeThrough:
        isActive = metadata.decoration == TextDecorationEnum.strikeThrough;
        break;
      case MetadataValue.baseText:
        break;
      case MetadataValue.headerText:
        isActive = metadata.fontSize == TextMetaDataStyles.headerText.fontSize;
        break;
    }
    return isActive;
  }
}
