import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/dependencies/extensions/date_time_extension.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/note_form_screen/screen/note_form_screen.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> animation;
  late final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    FlutterLogs.logInfo(
      'Presentation',
      'note-screen',
      'note ${widget.note.name}',
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.forward();
        Navigator.of(context)
            .pushNamed(NoteFormScreenWidget.screenName, arguments: widget.note)
            .whenComplete(() => controller.reverse());
      },
      onTapDown: (details) {
        controller.forward();
      },
      onTapCancel: () {
        controller.reverse();
      },
      child: Container(
        height: 70,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: animation.value,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                child: Text(
                  widget.note.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    reformatText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      color: AppColors.hintGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  widget.note.dateOfLastChange.getDateTimeString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.alexandria(
                    color: AppColors.hintGrey,
                    fontSize: 14,
                  ),
                ),
              ],
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

  String reformatText() {
    return widget.note.text.replaceAll('\n', ' ');
  }
}
