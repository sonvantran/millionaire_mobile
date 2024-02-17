import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.colorFF03456e,
            border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
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
