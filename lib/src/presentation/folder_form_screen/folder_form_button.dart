import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/icon_button.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';

class FolderFormButtonWidget extends StatefulWidget {
  const FolderFormButtonWidget({super.key, this.folder});

  final Folder? folder;

  @override
  State<FolderFormButtonWidget> createState() => _FolderFormButtonWidgetState();
}

class _FolderFormButtonWidgetState extends State<FolderFormButtonWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7.0, bottom: 5.0),
      child: AppIconButtonWidget(
        icon: AppIcons.addFolder,
        activeColor: AppColors.lightBrown,
        onPressed: () => FolderFormOverlayManager.buildOverlay(
          context: context,
          animation: animation!,
          animationController: animationController!,
        ),
        iconSize: 38,
        color: AppColors.darkBrown,
      ),
    );
  }

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
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
