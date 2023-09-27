import 'package:flutter/material.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import 'dart:math' as math;

class PointItem extends StatelessWidget {
  const PointItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorFFd1b037, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: -math.pi / 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(color: AppColors.colorFFa2602b),
            ),
          ),
          const SizedBox(width: 32),
          Text(
            text,
            style: TextStyles.mediumBlackS20,
          ),
          const SizedBox(width: 32),
          Transform.rotate(
            angle: -math.pi / 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(color: AppColors.colorFFa2602b),
            ),
          ),
        ],
      ),
    );
  }
}
