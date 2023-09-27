import 'package:flutter/material.dart';

import '../../../core/values/app_colors.dart';

class HelpItem extends StatelessWidget {
  const HelpItem({
    super.key,
    this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
    required this.checkExpire,
    required this.isHide,
  });

  final Widget? child;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final bool checkExpire;
  final bool isHide;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isHide ? 1 : 0.2,
      child: InkWell(
        onTap: checkExpire ? onTap : null,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.colorFF57B9FB,
                AppColors.colorFF03456e,
                AppColors.colorFF57B9FB,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: AppColors.colorFF77dbe5, width: 3),
          ),
          child: child,
        ),
      ),
    );
  }
}
