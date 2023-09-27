import 'package:flutter/material.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class ScoreUser extends StatelessWidget {
  const ScoreUser({super.key, required this.text});
  final int text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
          const Icon(
            Icons.monetization_on_rounded,
            color: AppColors.colorFFa2602b,
            size: 36,
          ),
          Text(
            '${formatNumber(text)} đ',
            style: TextStyles.mediumBlackS20,
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }

  String formatNumber(int i) {
    String formatted = "";
    String input = i.toString();
    int length = input.length;

    for (int i = length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = input[i] + formatted;
    }

    return formatted;
  }
}
