import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';

class FolderFormOverlayManager {
  FolderFormOverlayManager._();

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
    Folder? folder,
  }) {
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (appContext) {
        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FolderFormWidget(
              folder: folder ??
                  Folder(
                    id: -1,
                    name: 'Quick Notes',
                    background: AppColors.lightYellow,
                    icon: const Icon(
                      AppIcons.folder,
                      size: 28,
                    ),
                    dateOfCreation: DateTime.now(),
                  ),
              onClose: _removeHighlightOverlay,
              animation: animation,
              onDone: folder != null
                  ? DI.getInstance().folderPageCubit.onUpdateFolderClick
                  : DI.getInstance().folderPageCubit.onAddFolderClick,
              animationController: animationController,
            ),
          ),
        );
      },
    );

    _overlayState.insert(_overlayEntry!);
    animationController.forward();
  }
}
