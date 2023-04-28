import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/app_colors.dart';

class TitleInputWidget extends StatelessWidget {
  const TitleInputWidget({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        minLines: 1,
        maxLines: 2,
        autofocus: true,
        controller: titleController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 10),
          isCollapsed: true,
          hintText: 'Title',
          hintStyle: TextStyle(color: AppColors.hintGrey),
        ),
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        cursorColor: AppColors.darkBrown,
        cursorRadius: const Radius.circular(8.0),
      ),
    );
  }
}
