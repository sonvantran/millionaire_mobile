import 'package:flutter/material.dart';

import '../../../core/values/app_colors.dart';

class ButtonItem extends StatelessWidget {
  const ButtonItem({super.key, this.onTap, this.iconData, this.color});

  final void Function()? onTap;
  final IconData? iconData;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              // border: Border.all(color: AppColors.colorFFd1b037, width: 2),
              shape: BoxShape.circle,
              color: color),
          child: Icon(
            iconData,
            color: AppColors.colorFFFFFFFF,
          )),
    );
  }
}
