import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:notes/generated/locale_keys.g.dart';
import 'package:notes/src/domain/entity/item/note.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/note_form_screen/cubit/note_form_cubit.dart';
import 'package:notes/src/presentation/note_form_screen/screen/text_input/note_input_widget.dart';
import 'package:notes/src/presentation/note_form_screen/screen/text_style_bar/text_style_bar.dart';
import 'package:notes/src/presentation/notes_app.dart';
import 'package:notes/src/presentation/notes_screen/cubit/notes_screen_cubit.dart';
import 'package:notes/src/presentation/reusable_widgets/app_buttons/icon_button.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/dropdown_button_widget.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/dropdown_overlay.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_item_model.dart';

import 'action_bar/action_bar_widget.dart';

class NoteFormScreenWidget extends StatefulWidget {
  const NoteFormScreenWidget({
    super.key,
    required this.note,
    required this.notePageCubit,
  });

  final Note note;
  final NoteScreenCubit notePageCubit;
  static const screenName = '/note_form';

  @override
  State<NoteFormScreenWidget> createState() => _NoteFormScreenWidgetState();
}

class _NoteFormScreenWidgetState extends State<NoteFormScreenWidget>
    with RouteAware, TickerProviderStateMixin {
  late final List<DropDownItem> dropDownItems;
  late StreamSubscription<bool> keyboardSubscription;
  late NoteFormCubit cubit;
  late bool showActionBar;
  late final Future<void> screenLoad;
  late final AnimationController actionBarController;
  late final Animation<double> actionBarAnimation;

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
            FutureBuilder(
              future: screenLoad,
              builder: (context, snapshot) {
                if (ConnectionState.done == snapshot.connectionState) {
                  return NoteInputWidget(
                    controller: cubit.controller,
                    cubit: cubit,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            buildActionBarWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    showActionBar = false;
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
        showActionBar = false;
      } else {
        showActionBar = true;
      }
      setState(() {});
    });
    cubit = NoteFormCubit(
      widget.note,
      widget.notePageCubit,
    );
    screenLoad = cubit.onScreenLoad();
    dropDownItems = [
      DropDownItem(
        title: LocaleKeys.share.tr(),
        icon: AppIcons.share,
        actions: const [],
        onTap: () {},
      ),
      DropDownItem(
        title: LocaleKeys.save.tr(),
        icon: AppIcons.save,
        actions: const [],
        onTap: cubit.saveNote,
      ),
    ];

    actionBarController = AnimationController(
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );
    actionBarAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: actionBarController,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotesApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPop() {
    cubit.saveNote();
    DropDownOverlayManager.dispose();
    super.didPop();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    cubit.controller.dispose();
    actionBarController.dispose();
    NotesApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget buildActionBarWidget() {
    if (showActionBar) {
      actionBarController.forward();
    } else {
      actionBarController.reverse();
    }
    return ActionBarWidget(
      animation: actionBarAnimation,
      color: AppColors.light,
      cubit: cubit,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: TextStyleBar(cubit: cubit),
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: AppIconButtonWidget(
          icon: AppIcons.backChevron,
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: AppColors.darkBrown,
          activeColor: AppColors.lightToggledGrey,
        ),
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
