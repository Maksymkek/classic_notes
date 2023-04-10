import 'package:flutter/material.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_item_list.dart';

class DropDownOverlayManager {
  DropDownOverlayManager._();

  static late OverlayState _overlayState;
  static OverlayEntry? _overlayEntry;
  static Future<void> _removeHighlightOverlay(
    AnimationController animationController,
  ) async {
    await animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void buildFolderForm({
    required BuildContext context,
    required Animation<double> animation,
    required AnimationController animationController,
  }) {
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: Colors.transparent,
          child: Align(
            child: DropDownItemListWidget(
              itemAnimation: animation,
              onClose: _removeHighlightOverlay,
              overlayState: _overlayState,
              controller: animationController,
            ),
          ),
        );
      },
    );

    _overlayState.insert(_overlayEntry!);
    animationController.forward();
  }
}
