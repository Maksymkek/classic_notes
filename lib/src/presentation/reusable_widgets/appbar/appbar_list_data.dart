import 'package:flutter/material.dart';
import 'package:notes/src/domain/entity/item/folder.dart';
import 'package:notes/src/presentation/app_text_styles.dart';

class AppBarListData extends StatelessWidget {
  const AppBarListData({
    required this.title,
    this.folder,
    super.key,
  });

  final String title;
  final Folder? folder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 6),
      child: _buildListData(context),
    );
  }

  Widget _buildListData(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTextStyles.smallStyle),
        _buildFolderDetails(screenSize),
      ],
    );
  }

  Widget _buildFolderDetails(double screenSize) {
    if (folder != null) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(child: SizedBox()),
            Icon(
              folder?.icon.icon,
              size: 18,
            ),
            const SizedBox(width: 6.0),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize * 0.5),
              child: Text(
                folder?.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: AppTextStyles.smallStyle,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
