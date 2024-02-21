import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/local_saver/question_level.dart';

class GamePoint extends StatelessWidget {
  const GamePoint({super.key, required this.level, required this.mc});

  final int level;
  final int mc;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/nav_bg.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(32.r))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const GamePointItemNo1(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  for (final item in QuestionLevel.questionPoints(mc).reversed)
                    if (item.level != 15)
                      GamePointItem(
                        number: item.level.toString(),
                        point: item.point ?? '',
                        checkCurrent: item.level.compareTo(level),
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GamePointItem extends StatelessWidget {
  const GamePointItem(
      {super.key,
      required this.number,
      required this.point,
      required this.checkCurrent});

  final String number;
  final String point;
  final int checkCurrent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.colorFFd1b037.withOpacity(0),
                AppColors.colorFFd1b037,
              ],
            ),
          ),
          height: 2,
        )),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            gradient: checkCurrent > 0
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.colorFF57B9FB,
                      AppColors.colorFF03456e,
                      AppColors.colorFF57B9FB,
                    ],
                  )
                : checkCurrent < 0
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.colorFF72F672,
                          AppColors.colorFF3CC03C,
                          AppColors.colorFF72F672,
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.colorFF9BD7FF,
                          AppColors.colorFF5A8AAA,
                          AppColors.colorFF9BD7FF,
                        ],
                      ),
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            border: Border.all(color: AppColors.colorFFd1b037, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                number,
                style: TextStyles.mediumMWhiteS18,
              ),
              Text(
                "$point đ",
                style: TextStyles.mediumMWhiteS18,
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.colorFFd1b037,
                AppColors.colorFFd1b037.withOpacity(0),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class GamePointItemNo1 extends StatelessWidget {
  const GamePointItemNo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            'assets/images/cup_nav.png',
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.colorFFd1b037.withOpacity(0),
                      AppColors.colorFFd1b037,
                    ],
                  ),
                ),
                height: 2.h,
              )),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.colorFFf7d35a,
                      AppColors.colorFFf78f2b,
                      AppColors.colorFFf7d35a,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  border: Border.all(color: AppColors.colorFFd1b037, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15',
                      style: TextStyles.mediumMWhiteS18,
                    ),
                    Text(
                      "150.000.000 đ",
                      style: TextStyles.mediumMWhiteS18,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.colorFFd1b037,
                      AppColors.colorFFd1b037.withOpacity(0),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}
