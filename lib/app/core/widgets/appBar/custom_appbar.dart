// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../values/app_colors.dart';
import '../../values/text_styles.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.actions,
    required this.title,
    this.leading,
    this.top,
    this.bottom,
  });
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double? top;
  final double? bottom;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(top: top ?? 0, bottom: bottom ?? 0),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.colorFF77dbe5),
          color: AppColors.colorFF2a0e5c,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null) const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyles.mediumMWhiteS20,
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
            ),
          ),
          if (actions != null) const SizedBox(width: 8),
          Row(
            children: actions ?? [],
          )
        ],
      ),
    );
  }
}

class CustomAppbarItem extends StatelessWidget {
  const CustomAppbarItem({
    super.key,
    this.onPressed,
    this.background = AppColors.colorFF1F2A48,
    this.iconSize,
    this.icon,
    this.iconColor = AppColors.colorFFFFFFFF,
    this.width = 40,
    this.borderColor = AppColors.colorFF77dbe5,
  });
  final void Function()? onPressed;
  final Color background;
  final Color iconColor;
  final Color borderColor;
  final double? iconSize;
  final IconData? icon;
  // final String? iconAsset;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 9),
        width: width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: background,
            border: Border.all(color: borderColor)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
