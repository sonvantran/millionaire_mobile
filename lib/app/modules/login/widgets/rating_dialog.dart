import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/show_message_internal.dart';
import '../../../core/values/text_styles.dart';

class RatingPopup extends StatefulWidget {
  const RatingPopup({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  State<RatingPopup> createState() => _RatingPopupState();
}

class _RatingPopupState extends State<RatingPopup> {
  int number = 4;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      shadowColor: AppColors.colorFF000000,
      backgroundColor: AppColors.colorFF375193,
      title: Text(
        "Đánh Giá".toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyles.boldWhiteS24,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Bạn cảm thấy trải nghiệm với game như thế nào?",
            style: TextStyles.mediumWhiteS16,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              5,
              (index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (number != index) number = index;
                      });
                    },
                    child: SvgPicture.asset(index <= number
                        ? "assets/icons/ic_star.svg"
                        : "assets/icons/ic_star_non.svg"));
              },
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RatingButton(
                onPressed: () => Navigator.pop(context),
                label: "Quay lại",
                textStyle: TextStyles.regularWhiteS12,
                borderColor: AppColors.colorFF77dbe5,
                backgroundColor: AppColors.transparent,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: RatingButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final pre = await SharedPreferences.getInstance();
                  final isRating = pre.getBool("isRating") ?? false;
                  if (!isRating) await pre.setBool("isRating", true);
                  if (number == 4) {
                    widget.onPressed();
                    ShowMessageInternal.showMessage(
                        "Cảm ơn bạn! Bây giờ hãy đánh giá 5 sao trên Google Play nhé!");
                  } else {
                    AnalyticsManager.sendAnalyticsEvent(
                        'rating_${number + 1}');
                    if (!mounted) return;
                    ShowMessageInternal.showMessage("Cảm ơn đánh giá của bạn");
                  }
                },
                label: "Đánh giá",
                textStyle: TextStyles.regularWhiteS12,
                borderColor: AppColors.colorFF77dbe5,
                backgroundColor: AppColors.colorFF03456e,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RatingButton extends StatelessWidget {
  const RatingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.leftWidget,
  });

  final VoidCallback onPressed;
  final String label;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? leftWidget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              backgroundColor ?? AppColors.c000000_black),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 1,
              ),
            ),
          ),
          elevation: const MaterialStatePropertyAll(0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leftWidget != null
              ? Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: leftWidget,
                )
              : const SizedBox.shrink(),
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
