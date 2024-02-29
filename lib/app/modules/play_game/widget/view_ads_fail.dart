import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class ViewAdsFail extends StatelessWidget {
  const ViewAdsFail({super.key, this.onClose, this.onViewAds});

  final VoidCallback? onClose;
  final VoidCallback? onViewAds;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.colorFF000000.withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => onClose?.call(),
                child: Icon(
                  Icons.close,
                  size: 64.r,
                  color: AppColors.colorFFFFFFFF,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ối!",
                  style: TextStyles.boldWhiteS28,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset("assets/images/ic_smile.gif")),
                Text(
                  "Xem quảng cáo ngắn để chơi lại câu này!",
                  style: TextStyles.mediumMWhiteS18,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () => onViewAds?.call(),
                  child: Container(
                    height: 80.h,
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.colorFF0E8023,
                      border: Border.all(
                          color: AppColors.colorFFFFFFFF, width: 8.r),
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    child: Image.asset(
                      "assets/images/reward_icon.png",
                      color: AppColors.colorFFFFFFFF,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
