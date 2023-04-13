import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_styles.dart';

class FolderWidget extends StatefulWidget {
  const FolderWidget({
    super.key,
    required this.folder,
    this.previewMode = false,
  });

  final bool previewMode;
  final Folder folder;

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> animation;
  late final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    FlutterLogs.logInfo(
      'Presentation',
      'folder-screen',
      'folder${widget.folder.name}',
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.forward().whenComplete(() => controller.reverse());
      },
      onTapDown: (details) {
        controller.forward();
      },
      onTapCancel: () {
        controller.reverse();
      },
      child: Container(
        height: 52,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: widget.previewMode ? AppColors.white : animation.value,
        ),
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              height: double.maxFinite,
              width: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.folder.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: widget.folder.icon,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: SizedBox(
                child: Text(
                  widget.folder.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.middleBolderTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
      reverseDuration: const Duration(seconds: 1),
    );
    animation = ColorTween(
      begin: AppColors.lightGrey,
      end: AppColors.lightPressedGrey,
    ).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
