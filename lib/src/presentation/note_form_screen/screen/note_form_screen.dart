import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:notes/src/domain/entity/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/icon_button.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_button_widget.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_state.dart';
import 'package:notes/src/presentation/note_form_screen/screen/text_input/text_input_widget.dart';
import 'package:notes/src/presentation/note_form_screen/screen/text_input/title_input_widget.dart';
import 'package:notes/src/presentation/notes_app.dart';

import 'action_bar_widget.dart';

enum TextMode {
  normal,
  bold,
  italic,
}

const normalStyle = TextStyle();
const boldStyle = TextStyle(fontWeight: FontWeight.bold);
const italicStyle = TextStyle(fontStyle: FontStyle.italic);

// Helper method
TextStyle getStyle(TextMode mode) {
  switch (mode) {
    case TextMode.bold:
      return boldStyle;
    case TextMode.italic:
      return italicStyle;
    default:
      return normalStyle;
  }
}

class NoteFormScreenWidget extends StatefulWidget {
  const NoteFormScreenWidget({super.key, required this.note});

  final Note note;
  static const screenName = 'note_form';

  @override
  State<NoteFormScreenWidget> createState() => _NoteFormScreenWidgetState();
}

class _NoteFormScreenWidgetState extends State<NoteFormScreenWidget>
    with RouteAware {
  late final List<DropDownItem> dropDownItems;
  late final TextEditingController titleController;
  late final TextEditingController textController;
  var currentMode = TextMode.normal;
  late StreamSubscription<bool> keyboardSubscription;
  late NoteFormCubit cubit;
  late Color actionBarColor;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    titleController = TextEditingController(text: widget.note.name);
    titleController.selection = TextSelection.fromPosition(
      TextPosition(offset: titleController.text.length),
    );
    textController = TextEditingController(text: widget.note.text);
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
        actionBarColor = AppColors.white;
      } else {
        actionBarColor = AppColors.lightPressedGrey;
      }
      setState(() {});
    });
    cubit = NoteFormCubit(
      NoteForm(
        controller: textController,
        note: widget.note,
        buffer: [],
        currentBuffer: -1,
      ),
    );
    dropDownItems = [
      DropDownItem(
        title: 'Zoom in',
        icon: CupertinoIcons.zoom_in,
        actions: const [],
        onTap: () {},
      ),
      DropDownItem(
        title: 'Zoom out',
        icon: CupertinoIcons.zoom_out,
        actions: const [],
        onTap: () {},
      ),
      DropDownItem(
        title: 'Share',
        icon: CupertinoIcons.share,
        actions: const [],
        onTap: () {},
      ),
    ];
    actionBarColor = AppColors.white;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotesApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPop() {
    super.didPop();
    DropDownOverlayManager.dispose();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    titleController.dispose();
    textController.dispose();
    NotesApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: buildAppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            TitleInputWidget(titleController: titleController),
            BlocBuilder<NoteFormCubit, NoteForm>(
              bloc: cubit,
              builder: (context, state) {
                return TextInputWidget(textController: textController);
              },
            ),
            ActionBarWidget(color: actionBarColor),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      leading: AppIconButtonWidget(
        icon: CupertinoIcons.chevron_left,
        onPressed: () {
          Navigator.of(context).pop();
        },
        color: AppColors.darkBrown,
        activeColor: AppColors.lightBrown,
      ),
      scrolledUnderElevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 20),
          child: DropDownButtonWidget(dropdownItems: dropDownItems),
        ),
      ],
    );
  }
}
