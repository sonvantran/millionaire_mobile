import 'package:flutter/material.dart';

import '/app/core/values/app_colors.dart';

const defaultFontFamily = 'Baloo Thambi 2';
const defaultFontFamilyFallback = [
  'NotoSansJP',
  //'ZenMaruGothic',
];

abstract class FontW {
  static const small = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const mediumM = FontWeight.w600;
  static const bold = FontWeight.w700;
}

abstract class TextStyles {
  static const _medium14_07 = TextStyle(
    fontWeight: FontW.medium,
    fontSize: 14,
    letterSpacing: 0.7,
    color: AppColors.c1D1D1D_onSurface,
    fontFamily: defaultFontFamily,
    fontFamilyFallback: defaultFontFamilyFallback,
  );

  static const bold14TitleBold = _medium14_07;

  static const _medium16LineHeight24 = TextStyle(
    fontWeight: FontW.mediumM,
    fontSize: 16,
    letterSpacing: 0.7,
    color: AppColors.c1D1D1D_onSurface,
    fontFamily: defaultFontFamily,
  );
  static const small12LineHeight18RedSur = TextStyle(
    fontWeight: FontW.bold,
    fontSize: 12,
    letterSpacing: 0.7,
    color: AppColors.colorFF940000,
  );
  static const medium16LineHeight24Sur = _medium16LineHeight24;

  static const _medium14LineHeight21 = TextStyle(
    fontWeight: FontW.medium,
    fontSize: 14,
    letterSpacing: 0.7,
    color: AppColors.c1D1D1D_onSurface,
    fontFamily: defaultFontFamily,
  );
  static const medium14LineHeight21Sur = _medium14LineHeight21;
  static const _small12LineHeight18 = TextStyle(
    fontWeight: FontW.regular,
    fontSize: 12,
    letterSpacing: 0.7,
    color: AppColors.colorFF808089,
    fontFamily: defaultFontFamily,
  );

  static const small12LineHeight18Sur = _small12LineHeight18;

  static const small12LineHeight18BlackSur = _small12LineHeight18;

  static const regularWhiteS20 = TextStyle(
    fontSize: 20,
    color: AppColors.colorFFFFFFFF,
  );

  static const mediumMWhiteS20 = TextStyle(
    fontSize: 20,
    color: AppColors.colorFFFFFFFF,
    fontWeight: FontW.mediumM,
  );

  static const mediumBlackS20 = TextStyle(
    fontSize: 20,
    color: AppColors.colorFF000000,
    fontWeight: FontW.medium,
  );

  static const boldBlackS18 = TextStyle(
    color: AppColors.colorFF000000,
    fontSize: 18,
    fontWeight: FontW.bold,
  );
  static const boldRedS18 = TextStyle(
    color: AppColors.colorFFFF0000,
    fontSize: 18,
    fontWeight: FontW.bold,
  );

  static const size15 = TextStyle(
    fontSize: 15,
  );

  static const size14 = TextStyle(
    fontSize: 14,
  );

  static const size20 = TextStyle(
    fontSize: 20,
  );

  static const mediumMBlackS18 = TextStyle(
    fontWeight: FontW.mediumM,
    fontSize: 18,
  );

  static const regularMBlackS18 = TextStyle(
    fontWeight: FontW.regular,
    fontSize: 18,
  );

  static const mediumMBlueS16 = TextStyle(
    fontWeight: FontW.mediumM,
    fontSize: 16,
    color: AppColors.colorFF344054,
  );

  static const boldRedS20 = TextStyle(
    color: AppColors.colorFF940000,
    fontSize: 20,
    fontWeight: FontW.bold,
  );

  static const boldRedS40 = TextStyle(
    color: AppColors.colorFF9A0F0F,
    fontSize: 40,
    fontWeight: FontW.bold,
  );

  static const boldRed1S18 = TextStyle(
    color: AppColors.colorFF9A0F0F,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const regularBlueS18 = TextStyle(
    color: AppColors.colorFF2F394B,
    fontSize: 18,
  );

  static const mediumRedS20 = TextStyle(
    fontWeight: FontW.medium,
    fontSize: 20,
    color: AppColors.colorFFB20000,
  );

  static const mediumWhiteS14 = TextStyle(
    fontSize: 14,
    fontWeight: FontW.medium,
    color: AppColors.colorFFFFFFFF,
  );

  static const mediumWhitesS14 = TextStyle(
    fontSize: 14,
    fontWeight: FontW.medium,
    color: AppColors.colorFFBBBABA,
  );

  static const regularWhiteS12 = TextStyle(
    fontSize: 12,
    fontWeight: FontW.regular,
    color: AppColors.colorFFFFFFFF,
  );

  static const mediumRedS14 = TextStyle(
    fontSize: 14,
    fontWeight: FontW.medium,
    color: AppColors.colorFF940000,
  );

  static const mediumBlackkS14 = TextStyle(
    fontSize: 14,
    fontWeight: FontW.medium,
    color: AppColors.colorFF000000,
  );

  static const regularRedS13 = TextStyle(
    fontSize: 13,
    fontWeight: FontW.regular,
    color: AppColors.colorFFFF0000,
  );

  static const mediumWhiteS36 = TextStyle(
    fontWeight: FontW.medium,
    fontSize: 36,
    color: AppColors.colorFFFFFFFF,
  );

  static const regularBlackS14 = TextStyle(
    fontWeight: FontW.regular,
    fontSize: 14,
    color: AppColors.colorFF424242,
  );

  static const regularRedS14 = TextStyle(
    fontWeight: FontW.regular,
    fontSize: 14,
    color: AppColors.colorFF940000,
  );

  static const mediumBlackS42 = TextStyle(
    fontWeight: FontW.medium,
    fontSize: 36,
    height: 11 / 9,
    color: AppColors.colorFF000000,
  );

  static const smallBlackS24 = TextStyle(
    fontWeight: FontW.small,
    fontSize: 24,
    color: AppColors.colorFF000000,
  );

  static const regularBlackS16 = TextStyle(
    fontWeight: FontW.regular,
    fontSize: 16,
    color: AppColors.colorFF000000,
  );

  static const regularRedS16 = TextStyle(
    fontWeight: FontW.regular,
    fontSize: 16,
    color: AppColors.colorFF9A0F0F,
  );

  static const boldBlackS16 = TextStyle(
    color: AppColors.colorFF313131,
    fontSize: 16,
    fontWeight: FontW.bold,
  );

  static const mediumWhiteS16 = TextStyle(
    color: AppColors.colorFFFFFFFF,
    fontSize: 16,
    fontWeight: FontW.medium,
  );

  static const mediumMWhiteS24 = TextStyle(
    color: AppColors.colorFFFFFFFF,
    fontSize: 24,
    fontWeight: FontW.mediumM,
  );

  static const regularWhiteS18 = TextStyle(
      color: AppColors.colorFFFFFFFF,
      fontSize: 18,
      fontWeight: FontWeight.w400);

  static const boldWhiteS20 = TextStyle(
    color: AppColors.colorFFFFFFFF,
    fontSize: 20,
    fontWeight: FontW.bold,
  );

  static const mediumMWhiteS18 = TextStyle(
    color: AppColors.colorFFFFFFFF,
    fontSize: 18,
    fontWeight: FontW.mediumM,
  );

  static const boldWhiteS28 = TextStyle(
    color: AppColors.colorFFFFFFFF,
    fontSize: 28,
    fontWeight: FontW.bold,
  );

  static const boldBlackS28 = TextStyle(
    color: AppColors.colorFF000000,
    fontSize: 28,
    fontWeight: FontW.bold,
  );

  static const boldWhiteS24 = TextStyle(
    color: AppColors.colorFFFFFFFF,
    fontSize: 24,
    fontWeight: FontW.bold,
  );

  static const boldBlackS20 = TextStyle(
    color: AppColors.colorFF000000,
    fontSize: 20,
    fontWeight: FontW.bold,
  );

  static final mediumBlackS14 = TextStyle(
    color: AppColors.colorFF313131.withOpacity(0.5),
    fontSize: 14,
    fontWeight: FontW.medium,
  );

  static const greyS14 = TextStyle(
    color: AppColors.colorFF636363,
    fontSize: 14,
  );

  static const regularGrayS14 = TextStyle(
    color: AppColors.colorFF475467,
    fontSize: 14,
    fontWeight: FontW.regular,
  );
}
