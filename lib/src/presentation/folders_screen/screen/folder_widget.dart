import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/dependencies/extensions/date_time_extension.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/notes_screen/screen/notes_screen_widget.dart';

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
        if (!widget.previewMode) {
          controller.forward();
          Navigator.of(context)
              .pushNamed(NotesScreenWidget.screenName, arguments: widget.folder)
              .whenComplete(() {
            if (!controller.isDismissed) {
              try {
                if (!controller.isDismissed) {
                  controller.reverse();
                }
              } catch (_) {}
            }
          });
        }
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
        child: Stack(
          children: [
            Row(
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
                      style: const TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 2.0),
                child: Text(
                  widget.folder.dateOfLastChange.getDateTimeString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    color: AppColors.hintGrey,
                    fontSize: 11,
                  ),
                ),
              ),
            )
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
