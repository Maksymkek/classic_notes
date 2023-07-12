import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/notes_screen/screen/note_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/slidable_action/slidable_action.dart';

class NoteActionsWidget extends StatelessWidget {
  const NoteActionsWidget(
    this.note,
    this.cubit, {
    super.key,
  });

  final NotePageCubit cubit;
  final Note note;

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
                icon: AppIcons.trashBox,
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
