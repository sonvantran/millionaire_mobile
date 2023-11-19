import 'package:flutter/material.dart';

import '../../values/app_colors.dart';
import '../../values/custom_color.dart';
import '../../values/text_styles.dart';

class SecondButton extends StatelessWidget {
  const SecondButton({
    super.key,
    required this.text,
    this.style = TextStyles.boldWhiteS20,
    this.onTap,
    this.icon,
    this.gradient = CustomColor.xanh,
    required this.width,
    this.height,
  });

  final String text;
  final TextStyle style;
  final void Function()? onTap;
  final Widget? icon;
  final Gradient? gradient;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.colorFF03456e,
          border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(48)),
          gradient: gradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Row(
                children: [icon!, const SizedBox(width: 12)],
              ),
            Text(
              text,
              style: style,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
