import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_styles.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/dropdown_button_widget.dart';
import 'package:notes/src/presentation/common_widgets/drop_down_menu/models/dropdown_item_model.dart';

class BuildAppBar extends StatelessWidget {
  const BuildAppBar({
    super.key,
    required this.dropdownItems,
  });

  final List<DropDownItem> dropdownItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Notes', style: AppStyles.bigBoldTextStyle),
            actions: _appBarActions(),
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      DropDownButtonWidget(dropdownItems: dropdownItems),
      const SizedBox(width: 10),
    ];
  }
}
