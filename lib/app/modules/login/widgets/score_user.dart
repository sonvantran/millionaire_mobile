import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class ScoreUser extends StatelessWidget {
  const ScoreUser({super.key, required this.text});
  final int text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorFFd1b037, width: 2.r),
        borderRadius: BorderRadius.all(Radius.circular(40.r)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorFFf78f2b,
            AppColors.colorFFf7d35a,
            AppColors.colorFFf78f2b
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            color: AppColors.colorFFa2602b,
            size: 36.r,
          ),
          Text(
            '${formatNumber(text)} đ',
            style: TextStyles.mediumBlackS20,
          ),
          SizedBox(width: 8.w)
        ],
      ),
    );
  }

  String formatNumber(int i) {
    String formatted = "";
    String input = i.toString();
    int length = input.length;

    for (int i = length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = input[i] + formatted;
    }

    return formatted;
  }
}
