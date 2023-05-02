import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/folder.dart';
import 'package:notes/src/presentation/app_styles.dart';

class AppBarListData extends StatelessWidget {
  const AppBarListData({
    required this.title,
    this.folder,
    super.key,
    this.noteName,
  });

  final String title;
  final Folder? folder;
  final String? noteName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: buildListData(),
    );
  }

  Widget buildListData() {
    if (noteName == null) {
      return Row(
        children: [
          Text(
            title,
            style: AppStyles.smallTextStyle,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  folder?.icon.icon,
                  size: 18,
                ),
                const SizedBox(width: 6.0),
                Text(
                  folder?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.smallTextStyle,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Text(
          noteName!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.smallTextStyle,
          textAlign: TextAlign.left,
        ),
      );
    }
  }
}
