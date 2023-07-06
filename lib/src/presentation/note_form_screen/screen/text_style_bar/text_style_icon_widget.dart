import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';

class TextStyleIconWidget extends StatefulWidget {
  const TextStyleIconWidget({
    super.key,
    required this.icon,
    required this.metadataValue,
    required this.cubit,
  });

  final IconData icon;
  final NoteFormCubit cubit;
  final MetadataValue metadataValue;

  @override
  State<TextStyleIconWidget> createState() => _TextStyleIconWidgetState();
}

class _TextStyleIconWidgetState extends State<TextStyleIconWidget>
    with SingleTickerProviderStateMixin {
  late double iconSize;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormCubit, NoteForm>(
      bloc: widget.cubit,
      listenWhen: (prev, current) {
        return prev.currentMetadata.isMetaDataActive(widget.metadataValue) !=
            current.currentMetadata.isMetaDataActive(widget.metadataValue);
      },
      listener: (BuildContext context, state) {
        if (widget.cubit.state.currentMetadata
            .isMetaDataActive(widget.metadataValue)) {
          iconSize = 20;
        } else {
          iconSize = 0;
        }
        setState(() {});
      },
      child: AnimatedPadding(
        padding: iconSize == 20
            ? const EdgeInsets.symmetric(horizontal: 2.0)
            : EdgeInsets.zero,
        duration: const Duration(milliseconds: 250),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: iconSize),
          duration: const Duration(milliseconds: 250),
          builder: (BuildContext context, double size, Widget? child) {
            return Icon(
              widget.icon,
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
