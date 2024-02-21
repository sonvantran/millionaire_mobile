import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class UserRankingItem extends StatelessWidget {
  const UserRankingItem(
      {super.key,
      required this.number,
      required this.name,
      required this.point});

  final int number;
  final String name;
  final String point;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: number % 2 == 1
              ? [
                  AppColors.colorFF57B9FB,
                  AppColors.colorFF03456e,
                  AppColors.colorFF57B9FB,
                ]
              : [
                  AppColors.colorFF326D94,
                  AppColors.colorFF0B2D42,
                  AppColors.colorFF326D94,
                ],
        ),
        // border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
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
            child: Text(number.toString()),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyles.mediumWhiteS16,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 8.h),
                Text(
                  point,
                  style: TextStyles.mediumWhiteS14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
