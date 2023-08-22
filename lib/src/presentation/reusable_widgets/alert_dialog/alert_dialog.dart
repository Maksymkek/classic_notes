import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/generated/locale_keys.g.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_shadow.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/reusable_widgets/app_buttons/app_text_button.dart';

part 'package:notes/src/presentation/reusable_widgets/alert_dialog/alert_dialog_widget.dart';

class AppAlertDialog {
  static late OverlayState _overlayState;
  static late OverlayEntry _overlayEntry;

  static void _showDialog(
    BuildContext context,
    OverlayEntry overlayEntry,
  ) {
    _overlayState = Overlay.of(context);
    _overlayEntry = overlayEntry;
    _overlayState.insert(_overlayEntry);
  }

  static void showAlertDialog(
    BuildContext context,
    Function() onSubmit,
    String message,
  ) {
    _showDialog(
      context,
      OverlayEntry(
        builder: (context) {
          return _AlertDialogWidget(
            onSubmit: onSubmit,
            message: message,
          );
        },
      ),
    );
  }

  static void showMessageDialog(
    BuildContext context,
    String message,
  ) {
    _showDialog(
      context,
      OverlayEntry(
        builder: (context) {
          return _AlertDialogWidget(
            message: message,
          );
        },
      ),
    );
  }

  static void _onClose() {
    _overlayEntry.remove();
  }
}
