part of 'package:notes/src/presentation/reusable_widgets/alert_dialog/alert_dialog.dart';

class _AlertDialogWidget extends StatefulWidget {
  const _AlertDialogWidget({this.onSubmit, required this.message});

  final String message;
  final Function()? onSubmit;

  @override
  State<_AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<_AlertDialogWidget>
    with TickerProviderStateMixin {
  late double animationTargetValue;
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.05),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: animationTargetValue),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        builder: (context, progress, child) {
          return ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: progress, sigmaY: progress),
              child: child,
            ),
          );
        },
        child: Center(
          child: FadeTransition(
            opacity: animation,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 150,
                  maxWidth: 300,
                  maxHeight: 500,
                  minHeight: 100,
                ),
                child: ColoredBox(
                  color: AppColors.white.withOpacity(0.45),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildHeader(),
                        const SizedBox(height: 10),
                        Text(
                          widget.message,
                          maxLines: 4,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.darkGrey.withOpacity(0.85),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        buildButtons()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    if (widget.onSubmit == null) return const SizedBox();
    final textStyle = GoogleFonts.nunito(
      color: AppColors.darkGrey.withOpacity(0.85),
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );
    return Column(
      children: [
        const Divider(
          height: 20,
          color: AppColors.hintGrey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            buildButton(
              AppTextButtonWidget(
                text: LocaleKeys.cancel.tr(),
                onPressed: onClose,
                textSize: 18,
                color: AppColors.darkGrey.withOpacity(0.85),
                textStyle: textStyle,
                activeColor: AppColors.carmineRed.withOpacity(0.85),
              ),
            ),
            buildButton(
              AppTextButtonWidget(
                text: LocaleKeys.ok.tr(),
                textSize: 18,
                onPressed: () {
                  widget.onSubmit!();
                  onClose();
                },
                textStyle: textStyle,
                color: AppColors.darkGrey.withOpacity(0.85),
                activeColor: AppColors.brightBlue.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildButton(Widget child) {
    return Container(
      width: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: child,
    );
  }

  Widget buildHeader() {
    return Icon(
      widget.onSubmit != null
          ? CupertinoIcons.question_circle_fill
          : CupertinoIcons.exclamationmark_triangle,
      color: AppColors.darkGrey.withOpacity(0.85),
      size: 55,
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animationTargetValue = 20.0;
    controller.forward().whenComplete(() {
      if (widget.onSubmit == null) {
        Future.delayed(const Duration(milliseconds: 500)).whenComplete(onClose);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onClose() {
    animationTargetValue = 0.0;
    setState(() {});
    controller.reverse();
    Future.delayed(const Duration(milliseconds: 310))
        .whenComplete(AppAlertDialog._onClose);
  }
}
