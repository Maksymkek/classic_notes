import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';
import 'package:notes/src/presentation/reusable_widgets/progress_indicator/circle_progress_indicator.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({super.key});
  static const screenName = 'load_screen';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Center(child: CircleProgressIndicatorWidget()),
    );
  }
}
