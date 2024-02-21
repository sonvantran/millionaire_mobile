import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class TitleRanking extends StatelessWidget {
  const TitleRanking({super.key, this.check = true});

  final bool check;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: check
            ? BorderRadius.only(
                topLeft: Radius.circular(22.r),
                topRight: Radius.circular(22.r),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(22.r),
                bottomRight: Radius.circular(22.r),
              ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorFF326D94,
            AppColors.colorFF0B2D42,
            AppColors.colorFF326D94,
          ],
        ),
      ),
      child: check
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hạng",
                  style: TextStyles.mediumWhiteS14,
                ),
                SizedBox(width: 8.h),
                Text(
                  "Người chơi",
                  style: TextStyles.mediumWhiteS14,
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              child: Text(
                "Ai Là Triệu Phú",
                style: TextStyles.mediumWhitesS14,
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
