import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';

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
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [shadow],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.cubit.onTextEntered,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
          hintStyle: const TextStyle(color: AppColors.hintGrey),
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
    _controller = TextEditingController(text: widget.cubit.state.folder.name);
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
