import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';

class ActionsRowWidget extends StatelessWidget {
  const ActionsRowWidget({
    super.key,
    required this.cubit,
    required this.actions,
  });

  final NoteFormCubit cubit;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        border: Border.all(
          color: AppColors.darkGrey,
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actions,
        ),
      ),
    );
  }
}
