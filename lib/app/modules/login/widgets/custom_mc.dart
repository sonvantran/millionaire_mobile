import 'package:flutter/material.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';

class CustomMC extends StatelessWidget {
  const CustomMC(
      {super.key,
      this.onTap,
      this.avatar,
      required this.title,
      required this.value,
      this.groupValue,
      this.onChanged});
  final void Function()? onTap;
  final String? avatar;
  final String title;
  final Object value;
  final Object? groupValue;
  final void Function(Object?)? onChanged;

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.colorFFFFFFFF;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: AppColors.colorFF1F2A48,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        onTap: () {
          onChanged?.call(value);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: avatar != null
                          ? DecorationImage(
                              image: AssetImage(avatar!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: AppColors.colorFFD9D9D9),
                  child: avatar == null
                      ? const Icon(
                          Icons.person_2,
                          size: 24,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyles.regularWhiteS18,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(4),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.colorFFC5C5C5,
                  width: 1,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: groupValue == value ? activeColor : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
