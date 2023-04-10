import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/slidable_action.dart';
import 'package:notes/src/presentation/folder_form_screen/folder_form_overlay.dart';
import 'package:notes/src/presentation/folders_screen/cubit/folder_page_cubit.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_widget.dart';

class FolderActionsWidget extends StatefulWidget {
  const FolderActionsWidget({
    super.key,
    required this.folder,
    required this.cubit,
  });

  final FolderPageCubit cubit;
  final Folder folder;

  @override
  State<FolderActionsWidget> createState() => _FolderActionsWidgetState();
}

class _FolderActionsWidgetState extends State<FolderActionsWidget>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

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
      parent: animationController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset position) =>
          Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.5,
            children: [
              SlidableActionWidget(
                icon: Icons.edit_outlined,
                color: AppColors.brightBlue,
                onTap: () {
                  FolderFormOverlayManager.buildFolderForm(
                    context: context,
                    animation: animation,
                    folder: widget.folder,
                    animationController: animationController,
                  );
                },
              ),
              SlidableActionWidget(
                icon: Icons.delete_outline,
                color: AppColors.carmineRed,
                onTap: () {
                  widget.cubit.onDeleteFolderClick(widget.folder);
                },
              ),
            ],
          ),
          child: FolderWidget(
            folder: widget.folder,
          ),
        ),
      ),
    );
  }
}
