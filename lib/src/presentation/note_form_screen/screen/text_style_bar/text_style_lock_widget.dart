import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';
import 'package:notes/src/presentation/note_form_screen/note_text_controller/metadata_model/metadata_styles.dart';

class TextStyleLockWidget extends StatefulWidget {
  const TextStyleLockWidget({
    super.key,
    required this.cubit,
  });

  final NoteFormCubit cubit;

  @override
  State<TextStyleLockWidget> createState() => _TextStyleLockWidgetState();
}

class _TextStyleLockWidgetState extends State<TextStyleLockWidget> {
  late double iconSize;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormCubit, NoteForm>(
      bloc: widget.cubit,
      listenWhen: (prev, current) {
        return prev.currentMetadata != current.currentMetadata;
      },
      listener: (context, state) {
        if (state.currentMetadata.metadata ==
            TextMetaDataStyles.mainHeaderText) {
          setState(() {
            iconSize = 20;
          });
        } else {
          setState(() {
            iconSize = 0;
          });
        }
      },
      child: AnimatedPadding(
        padding: iconSize == 20 ? const EdgeInsets.all(3.0) : EdgeInsets.zero,
        duration: const Duration(milliseconds: 250),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: iconSize),
          duration: const Duration(milliseconds: 250),
          builder: (BuildContext context, double size, Widget? child) {
            return Icon(
              CupertinoIcons.padlock_solid,
              size: size,
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    iconSize = 0;
  }
}
