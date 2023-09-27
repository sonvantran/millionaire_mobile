import 'package:flutter/material.dart';

import '../../values/app_colors.dart';
import '../../values/text_styles.dart';
import '../button/primary_button.dart';

class PopupPlayConfirm extends StatelessWidget {
  const PopupPlayConfirm({
    super.key,
    required this.title,
    required this.titleButton1,
    this.titleButton2 = 'Thoát',
    required this.onTap,
    this.content,
  });
  final String title;
  final String? content;
  final String titleButton1;
  final String titleButton2;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.mediumMBlackS18,
      ),
      content: content != null
          ? Text(
              content!,
              textAlign: TextAlign.center,
              style: TextStyles.size14,
            )
          : null,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Column(
          children: [
            PrimaryButton(
              onTap: () => Navigator.pop(context),
              title: titleButton1,
              backgroundColor: AppColors.colorFF03456e,
              textColor: AppColors.colorFFFFFFFF,
              textSize: 16,
              borderColor: AppColors.colorFF03456e,
              textWeight: FontWeight.w600,
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              onTap: onTap,
              title: titleButton2,
              borderColor: AppColors.colorFFD0D5DD,
              backgroundColor: AppColors.colorFFFFFFFF,
              textColor: AppColors.colorFF344054,
              textSize: 16,
              textWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
