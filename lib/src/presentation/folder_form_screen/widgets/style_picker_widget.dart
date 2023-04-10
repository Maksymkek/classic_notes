import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_cubit.dart';
import 'package:notes/src/presentation/folder_form_screen/cubit/folder_form_state.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/color_picker_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/folder_form_widget.dart';
import 'package:notes/src/presentation/folder_form_screen/widgets/icon_picker_widget.dart';

class StylePickerWidget extends StatefulWidget {
  const StylePickerWidget({super.key, required this.cubit});
  final FolderFormCubit cubit;

  @override
  State<StylePickerWidget> createState() => _StylePickerWidgetState();
}

class _StylePickerWidgetState extends State<StylePickerWidget> {
  late final ScrollController colorPickerController;
  late final ScrollController iconPickerController;

  @override
  void initState() {
    super.initState();
    colorPickerController = ScrollController();
    iconPickerController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 124,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 13),
          BlocBuilder<FolderFormCubit, FolderFormState>(
            bloc: widget.cubit,
            buildWhen: (prev, current) {
              return prev.colorPickers != current.colorPickers;
            },
            builder: (context, snapshot) {
              return _ItemPickerWidget(
                listView: buildColorPickerList(),
                controller: colorPickerController,
              );
            },
          ),
          BlocBuilder<FolderFormCubit, FolderFormState>(
            bloc: widget.cubit,
            buildWhen: (prev, current) {
              return prev.iconPickers != current.iconPickers;
            },
            builder: (context, state) {
              return _ItemPickerWidget(
                listView: buildIconPickerList(),
                controller: iconPickerController,
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    colorPickerController.dispose();
    iconPickerController.dispose();
    super.dispose();
  }

  ListView buildIconPickerList() {
    return ListView.builder(
      controller: iconPickerController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.cubit.state.iconPickers.length,
      itemBuilder: (BuildContext context, int index) {
        var iconPicker = widget.cubit.state.iconPickers[index];
        return IconPickerWidget(
          model: iconPicker,
          onPressed: widget.cubit.onIconSelected,
        );
      },
    );
  }

  ListView buildColorPickerList() {
    return ListView.builder(
      controller: colorPickerController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.cubit.state.colorPickers.length,
      itemBuilder: (BuildContext context, int index) {
        var colorPicker = widget.cubit.state.colorPickers[index];
        return ColorPickerWidget(
          model: colorPicker,
          onPressed: widget.cubit.onColorSelected,
        );
      },
    );
  }
}

class _ItemPickerWidget extends StatelessWidget {
  const _ItemPickerWidget({
    required this.listView,
    required this.controller,
  });

  final ListView listView;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 41),
      child: Container(
        width: double.maxFinite,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: RawScrollbar(
          pressDuration: const Duration(milliseconds: 100),
          controller: controller,
          thickness: 2.0,
          trackVisibility: true,
          thumbColor: AppColors.black,
          thumbVisibility: true,
          radius: const Radius.circular(2.0),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          trackRadius: const Radius.circular(2.0),
          trackColor: Colors.grey,
          interactive: true,
          child: listView,
        ),
      ),
    );
  }
}
