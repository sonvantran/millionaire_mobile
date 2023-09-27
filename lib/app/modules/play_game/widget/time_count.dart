import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class TimeCount extends StatelessWidget {
  const TimeCount({super.key, required this.text, required this.isLoading});

  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.colorFF57B9FB,
                AppColors.colorFF03456e,
                AppColors.colorFF57B9FB,
              ],
            ),
            border: Border.all(color: AppColors.colorFF77dbe5, width: 3),
          ),
          child: Text(
            text,
            style: TextStyles.boldWhiteS28,
          ),
        ),
        if (isLoading)
          SpinKitDualRing(
            duration: const Duration(milliseconds: 2000),
            size: (int.parse(text) < 10) ? 60 : 74,
            color: AppColors.colorFF1F2A48,
          )
      ],
    );
  }
}
