import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/app_icons.dart';
import 'package:notes/src/presentation/app_text_styles.dart';
import 'package:notes/src/presentation/reusable_widgets/drop_down_menu/models/dropdown_action_model.dart';

class DropDownActionWidget extends StatelessWidget {
  const DropDownActionWidget({super.key, required this.action});

  final DropDownAction action;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: action.tapResponseColor ?? AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.2),
        child: SizedBox(
          width: 200,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 16,
                child: Icon(
                  action.icon,
                  size: action.iconSize ?? 16,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              buildTextWidget(),
              const Expanded(child: SizedBox()),
              buildSelectionIconWidget()
            ],
          ),
        ),
      ),
    );
  }

  AnimatedCrossFade buildSelectionIconWidget() {
    return AnimatedCrossFade(
      firstChild: const Row(
        children: [
          Icon(
            AppIcons.selected,
            size: 14,
            color: AppColors.darkBrown,
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      crossFadeState: action.isSelected
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      secondChild: Container(),
      duration: const Duration(milliseconds: 150),
    );
  }

  SizedBox buildTextWidget() {
    return SizedBox(
      width: 130,
      child: Text(
        action.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.smallDropDownStyle,
      ),
    );
  }
}
