import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/metadata/font_style_data.dart';
import 'package:notes/src/presentation/note_form_screen/screen/text_style_bar/text_style_icon_widget.dart';
import 'package:notes/src/presentation/note_form_screen/screen/text_style_bar/text_style_lock_widget.dart';

class TextStyleBar extends StatelessWidget {
  const TextStyleBar({super.key, required this.cubit});

  final NoteFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTextStylingLock(),
        buildTextStyleIcon(CupertinoIcons.chevron_up, MetadataValue.headerText),
        //const SizedBox(width: 10),
        AnimatedContainer(
          constraints: const BoxConstraints(minHeight: 14, minWidth: 30),
          duration: const Duration(seconds: 1),
          curve: Curves.elasticInOut,
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextStyleIcon(
                  CupertinoIcons.bold,
                  MetadataValue.bold,
                ),
                buildTextStyleIcon(
                  CupertinoIcons.italic,
                  MetadataValue.italic,
                ),
                buildTextStyleIcon(
                  CupertinoIcons.underline,
                  MetadataValue.underline,
                ),
                buildTextStyleIcon(
                  CupertinoIcons.strikethrough,
                  MetadataValue.strikeThrough,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextStylingLock() {
    return TextStyleLockWidget(cubit: cubit);
  }

  Widget buildTextStyleIcon(IconData icon, MetadataValue metadataValue) {
    return TextStyleIconWidget(
      icon: icon,
      metadataValue: metadataValue,
      cubit: cubit,
    );
  }
}
