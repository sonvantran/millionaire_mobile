import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';

class AppBarItem extends StatelessWidget {
  const AppBarItem({
    super.key,
    this.child,
    this.onTap,
    this.isCheck,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  final Widget? child;
  final void Function()? onTap;
  final bool? isCheck;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        margin: EdgeInsets.only(top: 8.h),
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
          borderRadius: isCheck != null
              ? BorderRadius.only(
                  topLeft: isCheck! ? const Radius.circular(32) : Radius.zero,
                  topRight: !isCheck! ? const Radius.circular(32) : Radius.zero,
                  bottomLeft:
                      isCheck! ? const Radius.circular(32) : Radius.zero,
                  bottomRight:
                      !isCheck! ? const Radius.circular(32) : Radius.zero,
                )
              : null,
          border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
        ),
        child: child,
      ),
    );
  }
}
