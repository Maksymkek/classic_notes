import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:rich_text_editor_controller/rich_text_editor_controller.dart';

class NoteInputWidget extends StatelessWidget {
  const NoteInputWidget({
    super.key,
    required this.controller,
    required this.cubit,
  });

  final RichTextEditorController controller;
  final NoteFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool enabled = true;
            if (orientation == Orientation.landscape &&
                MediaQuery.of(context).size.height < 700) enabled = false;

            return RichTextField(
              minLines: null,
              expands: true,
              maxLines: null,
              autocorrect: false,
              enabled: enabled,
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                hintText: 'Enter text of the note',
                hintStyle: AppTextStyles.bigHintStyle,
              ),
              onChanged: cubit.onTextChanged,
              style: GoogleFonts.varelaRound(fontSize: 19),
              cursorColor: AppColors.darkGrey,
              cursorRadius: const Radius.circular(8.0),
              //onChanged: ,
            );
          },
        ),
      ),
    );
  }
}
