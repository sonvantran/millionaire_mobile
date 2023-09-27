import 'package:flutter/material.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class AnswerItem extends StatelessWidget {
  const AnswerItem(
      {super.key,
      required this.text,
      required this.type,
      this.onTap,
      required this.isChoose,
      required this.isTrue,
      required this.checkExpire,
      required this.isHide});

  final String text;
  final String type;
  final void Function()? onTap;
  final bool isChoose;
  final bool isTrue;
  final bool checkExpire;
  final bool isHide;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: checkExpire && !isHide ? onTap : null,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          gradient: isTrue
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.colorFF0E8023,
                    AppColors.colorFF3CC03C,
                    AppColors.colorFF0E8023
                  ],
                )
              : isChoose
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.colorFFf78f2b,
                        AppColors.colorFFf7d35a,
                        AppColors.colorFFf78f2b
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
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          border: Border.all(color: AppColors.colorFF77dbe5, width: 3),
        ),
        child: Text(
          !isHide ? '$type. $text' : '',
          style: TextStyles.mediumWhiteS16,
          overflow: TextOverflow.ellipsis,
          maxLines: 10,
        ),
      ),
    );
  }
}
