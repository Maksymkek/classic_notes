import 'package:flutter/material.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/widgets/dropdown_item_list.dart';

class DropDownOverlayManager {
  DropDownOverlayManager._();

  static late OverlayState _overlayState;
  static OverlayEntry? _overlayEntry;
  static AnimationController? _otherController;
  static late AnimationController _menuController;

  static void buildOverlay({
    required BuildContext context,
    required Animation<double> animation,
    required AnimationController animationController,
    AnimationController? otherController,
    required List<DropDownItem> dropDownItems,
  }) {
    _menuController = animationController;
    _otherController = otherController;
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: Colors.transparent,
          child: Align(
            child: DropDownItemListWidget(
              key: context.widget.key,
              itemAnimation: animation,
              onClose: _removeHighlightOverlay,
              overlayState: _overlayState,
              dropDownItems: dropDownItems,
            ),
          ),
        );
      },
    );
    _otherController?.forward();
    _overlayState.insert(_overlayEntry!);
    animationController.forward();
  }

  static Future<void> _removeHighlightOverlay() async {
    _otherController?.reverse();
    await _menuController.reverse();
    dispose();
  }

  static void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
