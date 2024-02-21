import 'package:flutter/material.dart';

import '../../values/app_colors.dart';
import '../../values/custom_color.dart';
import '../../values/text_styles.dart';

class AdsButton extends StatelessWidget {
  const AdsButton({
    super.key,
    required this.text,
    this.onTap,
    required this.icon,
    this.gradient = CustomColor.dung,
  });

  final String text;
  final void Function()? onTap;
  final Widget icon;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.colorFF03456e,
          border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          gradient: gradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyles.boldWhiteS20,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
