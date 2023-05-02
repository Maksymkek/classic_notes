import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({
    super.key,
    required this.textController,
  });

  final TextEditingController textController;
//TODO undoHistoryController
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
          minLines: null,
          maxLines: null,
          expands: true,
          controller: textController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
            hintText: 'Text',
            hintStyle: TextStyle(color: AppColors.hintGrey),
          ),
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          cursorColor: AppColors.darkBrown,
          cursorRadius: const Radius.circular(8.0),
        ),
      ),
    );
  }
}
