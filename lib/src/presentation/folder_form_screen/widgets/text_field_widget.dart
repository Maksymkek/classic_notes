import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_shadow.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({super.key, required this.cubit});

  final FolderFormCubit cubit;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [AppShadow.baseShadow],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.cubit.onTextEntered,
        style: AppTextStyles.middleStyle.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.white,
          filled: true,
          hintStyle: AppTextStyles.smallHintStyle
              .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          hintText: 'Folder name',
          contentPadding: const EdgeInsets.all(10.0),
          isCollapsed: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.cubit.state.folder.title);
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
