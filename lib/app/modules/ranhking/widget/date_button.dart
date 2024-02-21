import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class DateButton extends StatelessWidget {
  const DateButton(
      {super.key, required this.text, this.onTap, required this.isChoose});

  final String text;
  final void Function()? onTap;
  final bool isChoose;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: !isChoose ? onTap : null,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.colorFF03456e,
            border: Border.all(color: AppColors.colorFF77dbe5, width: 2.r),
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
            gradient: isChoose
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.colorFF0E8023,
                      AppColors.colorFF3CC03C,
                      AppColors.colorFF0E8023
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.colorFF57B9FB,
                      AppColors.colorFF03456e,
                      AppColors.colorFF57B9FB,
                    ],
                  ),
          ),
          child: Text(
            text,
            style: TextStyles.boldWhiteS20,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
