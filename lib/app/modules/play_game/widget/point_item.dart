import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import 'dart:math' as math;

class PointItem extends StatelessWidget {
  const PointItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorFFd1b037, width: 2.w),
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
          Transform.rotate(
            angle: -math.pi / 4,
            child: Container(
              width: 12.w,
              height: 12.h,
              decoration: const BoxDecoration(color: AppColors.colorFFa2602b),
            ),
          ),
          SizedBox(width: 32.w),
          Text(
            text,
            style: TextStyles.mediumBlackS20,
          ),
          SizedBox(width: 32.w),
          Transform.rotate(
            angle: -math.pi / 4,
            child: Container(
              width: 12.w,
              height: 12.h,
              decoration: const BoxDecoration(color: AppColors.colorFFa2602b),
            ),
          ),
        ],
      ),
    );
  }
}
