import 'package:flutter/cupertino.dart';
import 'package:notes/src/presentation/app_colors.dart';

class CircleProgressIndicatorWidget extends StatelessWidget {
  const CircleProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator(
      radius: 20,
      color: AppColors.darkGrey,
      animating: true,
    );
  }
}
