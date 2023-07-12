import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

extension EquatableTextMetadata on TextMetadata {
  ///extension on [TextMetadata] to compare parameters instead of object
  bool isEqualTo(TextMetadata other) {
    if (color != other.color ||
        fontSize != other.fontSize ||
        fontWeight != other.fontWeight ||
        fontStyle != other.fontStyle ||
        decoration != other.decoration ||
        alignment != other.alignment) {
      return false;
    }
    return true;
  }
}
