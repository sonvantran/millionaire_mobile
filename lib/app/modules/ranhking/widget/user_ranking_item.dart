import 'package:flutter/widgets.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class UserRankingItem extends StatelessWidget {
  const UserRankingItem(
      {super.key,
      required this.number,
      required this.name,
      required this.point});

  final String number;
  final String name;
  final String point;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.colorFF57B9FB,
            AppColors.colorFF03456e,
            AppColors.colorFF57B9FB,
          ],
        ),
        border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.colorFFf78f2b,
                  AppColors.colorFFf7d35a,
                  AppColors.colorFFf78f2b
                ],
              ),
            ),
            child: Text(number),
          ),
          const SizedBox(width: 8),
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
                const SizedBox(height: 8),
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
