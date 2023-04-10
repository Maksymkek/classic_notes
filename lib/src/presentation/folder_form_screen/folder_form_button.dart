import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';

class FolderFormButtonWidget extends StatefulWidget {
  const FolderFormButtonWidget({Key? key, this.folder}) : super(key: key);
  final Folder? folder;

  @override
  State<FolderFormButtonWidget> createState() => _FolderFormButtonWidgetState();
}

class _FolderFormButtonWidgetState extends State<FolderFormButtonWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 350),
      vsync: this,
    );
    animation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        AppIcons.addFolder,
      ),
      onPressed: () => FolderFormOverlayManager.buildFolderForm(
        context: context,
        animation: animation!,
        animationController: animationController!,
      ),
      iconSize: 36,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }
}
