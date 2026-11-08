import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../data/model/user.dart';
import '../../values/app_colors.dart';
import '../../values/text_styles.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.user, this.radius});

  final User user;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius ?? 40.w,
      height: radius ?? 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: generateRandomDarkColor(),
        border: Border.all(color: AppColors.colorFF77dbe5),
      ),
      child: user.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100.r)),
              child: Image.network(
                user.image!,
                width: radius ?? 40.w,
                height: radius ?? 40.h,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : SpinKitFadingCircle(
                        color: AppColors.colorFF57B9FB,
                        size: 25.r,
                      ),
                errorBuilder: (context, error, stack) {
                  debugPrint('AVATAR ERR url=${user.image} error=$error');
                  return const Icon(Icons.error);
                },
              ),
            )
          : Text(
              runeSubstring(user.name, 0, 1),
              textAlign: TextAlign.center,
              style: TextStyles.mediumWhiteS14,
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
            ),
    );
  }

  String runeSubstring(String input, int start, int end) {
    if (input.isEmpty) return '';
    return String.fromCharCodes(
      input.runes.toList().sublist(start, end),
    ).toUpperCase();
  }

  Color generateRandomDarkColor() {
    Random random = Random();

    int red = random.nextInt(128);
    int green = random.nextInt(128);
    int blue = random.nextInt(128);

    Color color = Color.fromARGB(255, red, green, blue);

    return color;
  }
}
