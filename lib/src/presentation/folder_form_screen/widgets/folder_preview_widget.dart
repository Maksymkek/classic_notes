import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';
import 'package:notes/src/presentation/folders_screen/screen/folder_widget.dart';

class FolderPreviewWidget extends StatelessWidget {
  const FolderPreviewWidget({super.key, required this.cubit});
  final FolderFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [shadow],
          ),
          child: BlocBuilder<FolderFormCubit, FolderFormState>(
            bloc: cubit,
            builder: (context, snapshot) {
              return FolderWidget(
                folder: cubit.state.folder,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'preview',
                style: GoogleFonts.acme(fontSize: 12),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        )
      ],
    );
  }
}
