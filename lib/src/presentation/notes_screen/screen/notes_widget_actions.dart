import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/slidable_action.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/screen/note_widget.dart';

class NoteActionsWidget extends StatelessWidget {
  const NoteActionsWidget({
    super.key,
    required this.note,
    required this.cubit,
    required this.animationController,
    required this.animation,
  });

  final NotePageCubit cubit;
  final Note note;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset position) =>
          Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Slidable(
          key: ValueKey(note.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                cubit.onDeleteNoteClick(note);
              },
            ),
            extentRatio: 0.25,
            children: [
              SlidableActionWidget(
                icon: CupertinoIcons.delete,
                color: AppColors.carmineRed,
                onTap: () {
                  cubit.onDeleteNoteClick(note);
                },
              ),
            ],
          ),
          child: NoteWidget(
            note: note,
            cubit: cubit,
          ),
        ),
      ),
    );
  }
}
