import 'package:flutter/material.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class TitleRanking extends StatelessWidget {
  const TitleRanking({super.key, this.check = true});

  final bool check;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: check
            ? const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              )
            : const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
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
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hạng",
                  style: TextStyles.mediumWhiteS14,
                ),
                SizedBox(width: 8),
                Text(
                  "Người chơi",
                  style: TextStyles.mediumWhiteS14,
                ),
              ],
            )
          : const SizedBox(
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
