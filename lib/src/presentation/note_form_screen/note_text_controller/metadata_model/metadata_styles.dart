import 'package:flutter/material.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

abstract class TextMetaDataStyles {
  static const TextMetadata baseText = TextMetadata(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFeatures: null,
  );

  static const TextMetadata mainHeaderText = TextMetadata(
    fontWeight: FontWeight.bold,
    fontSize: 26,
    fontFeatures: null,
  );

  static const TextMetadata headerText = TextMetadata(
    fontWeight: FontWeight.w500,
    fontSize: 22,
    fontFeatures: null,
  );

  void init() {}
}
