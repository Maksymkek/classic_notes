import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';
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
        child: RichTextField(
          minLines: null,
          expands: true,
          maxLines: null,
          autocorrect: false,
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 10),
            isCollapsed: true,
            hintText: 'Enter text of the note',
            hintStyle: TextStyle(color: AppColors.hintGrey, fontSize: 26),
          ),
          onChanged: cubit.onTextChanged,
          style: GoogleFonts.roboto(
            fontSize: 18,
          ),
          cursorColor: AppColors.darkBrown,
          cursorRadius: const Radius.circular(8.0),
          //onChanged: ,
        ),
      ),
    );
  }
}
