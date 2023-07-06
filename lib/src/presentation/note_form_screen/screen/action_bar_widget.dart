import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/common_widgets/app_buttons/icon_button.dart';

class ActionBarWidget extends StatelessWidget {
  const ActionBarWidget({
    super.key,
    required this.color,
  });
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      height: 50,
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          AppIconButtonWidget(
            icon: CupertinoIcons.chevron_left,
            onPressed: () {},
            color: AppColors.darkBrown,
            activeColor: AppColors.lightBrown,
            iconSize: 28,
          ),
          AppIconButtonWidget(
            icon: CupertinoIcons.increase_indent,
            onPressed: () {},
            color: AppColors.darkBrown,
            activeColor: AppColors.lightBrown,
            iconSize: 28,
          ),
          AppIconButtonWidget(
            icon: CupertinoIcons.list_bullet,
            onPressed: () {},
            color: AppColors.darkBrown,
            activeColor: AppColors.lightBrown,
            iconSize: 28,
          ),
          AppIconButtonWidget(
            icon: CupertinoIcons.square_on_square,
            onPressed: () {},
            color: AppColors.darkBrown,
            activeColor: AppColors.lightBrown,
            iconSize: 28,
          ),
          AppIconButtonWidget(
            icon: CupertinoIcons.chevron_right,
            onPressed: () {},
            color: AppColors.darkBrown,
            activeColor: AppColors.lightBrown,
            iconSize: 28,
          )
        ],
      ),
    );
  }
}
