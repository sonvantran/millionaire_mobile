import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class Question extends StatelessWidget {
  const Question({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorFFFFFFFF,
            AppColors.colorFFBBBABA,
            AppColors.colorFFFFFFFF,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
        border: Border.all(color: AppColors.colorFF77dbe5, width: 3.w),
      ),
      child: Text(
        text,
        style: TextStyles.boldBlackS20,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 10,
      ),
    );
  }
}
