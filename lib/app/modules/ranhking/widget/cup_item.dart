import 'package:flutter/widgets.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class CupItem extends StatelessWidget {
  const CupItem(
      {super.key,
      this.width = 100,
      required this.asset,
      this.padding,
      required this.name,
      required this.point});

  final double? width;
  final String asset;
  final EdgeInsetsGeometry? padding;
  final String name;
  final String point;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width,
              child: Image.asset('assets/images/$asset.png'),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.colorFF000000,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: TextStyles.mediumWhiteS14,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    point,
                    style: TextStyles.regularWhiteS12,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
