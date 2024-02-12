import 'package:flutter/material.dart';

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
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nav_bg.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(32))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const GamePointItemNo1(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(bottom: 2),
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
            borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          padding: const EdgeInsets.only(top: 50),
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
                height: 2,
              )),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                margin: const EdgeInsets.only(bottom: 2),
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
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: AppColors.colorFFd1b037, width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15',
                      style: TextStyles.mediumMWhiteS18,
                    ),
                    Text(
                      "250.000.000 đ",
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


// import 'package:flutter/material.dart';

// import '../../../core/values/app_colors.dart';
// import '../../../core/values/text_styles.dart';
// import '../../../data/local_saver/question_level.dart';

// class GamePoint extends StatelessWidget {
//   const GamePoint({super.key, this.onTap, required this.level});

//   final void Function()? onTap;
//   final int level;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Row(
//       children: [
//         Expanded(
//           child: InkWell(
//             onTap: onTap,
//             child: Container(
//               height: double.infinity,
//               color: AppColors.colorFF000000.withOpacity(0.5),
//             ),
//           ),
//         ),
//         Container(
//           height: size.height,
//           width: size.width * 0.8,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/nav_bg.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const GamePointItemNo1(),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 18),
//                 child: Column(
//                   children: [
//                     for (final item in QuestionLevel.questionPoints.reversed)
//                       if (item.level != 15)
//                         GamePointItem(
//                           number: item.level.toString(),
//                           point: item.point ?? '',
//                           checkCurrent: item.level.compareTo(level),
//                         )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class GamePointItem extends StatelessWidget {
//   const GamePointItem(
//       {super.key,
//       required this.number,
//       required this.point,
//       required this.checkCurrent});

//   final String number;
//   final String point;
//   final int checkCurrent;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//             child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [
//                 AppColors.colorFFd1b037.withOpacity(0),
//                 AppColors.colorFFd1b037,
//               ],
//             ),
//           ),
//           height: 2,
//         )),
//         Container(
//           width: MediaQuery.of(context).size.width * 0.5,
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           margin: const EdgeInsets.only(bottom: 2),
//           decoration: BoxDecoration(
//             gradient: checkCurrent > 0
//                 ? const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       AppColors.colorFF57B9FB,
//                       AppColors.colorFF03456e,
//                       AppColors.colorFF57B9FB,
//                     ],
//                   )
//                 : checkCurrent < 0
//                     ? const LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           AppColors.colorFF72F672,
//                           AppColors.colorFF3CC03C,
//                           AppColors.colorFF72F672,
//                         ],
//                       )
//                     : const LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           AppColors.colorFF9BD7FF,
//                           AppColors.colorFF5A8AAA,
//                           AppColors.colorFF9BD7FF,
//                         ],
//                       ),
//             borderRadius: const BorderRadius.all(Radius.circular(12)),
//             border: Border.all(color: AppColors.colorFFd1b037, width: 2),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 number,
//                 style: TextStyles.mediumMWhiteS18,
//               ),
//               Text(
//                 "$point đ",
//                 style: TextStyles.mediumMWhiteS18,
//               )
//             ],
//           ),
//         ),
//         Expanded(
//             child: Container(
//           height: 2,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [
//                 AppColors.colorFFd1b037,
//                 AppColors.colorFFd1b037.withOpacity(0),
//               ],
//             ),
//           ),
//         )),
//       ],
//     );
//   }
// }

// class GamePointItemNo1 extends StatelessWidget {
//   const GamePointItemNo1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Center(
//           child: Image.asset(
//             'assets/images/cup_nav.png',
//             width: MediaQuery.of(context).size.width * 0.3,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 50),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                     colors: [
//                       AppColors.colorFFd1b037.withOpacity(0),
//                       AppColors.colorFFd1b037,
//                     ],
//                   ),
//                 ),
//                 height: 2,
//               )),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.6,
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                 margin: const EdgeInsets.only(bottom: 2),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       AppColors.colorFFf7d35a,
//                       AppColors.colorFFf78f2b,
//                       AppColors.colorFFf7d35a,
//                     ],
//                   ),
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   border: Border.all(color: AppColors.colorFFd1b037, width: 2),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '15',
//                       style: TextStyles.mediumMWhiteS18,
//                     ),
//                     Text(
//                       "150.000.000 đ",
//                       style: TextStyles.mediumMWhiteS18,
//                     )
//                   ],
//                 ),
//               ),
//               Expanded(
//                   child: Container(
//                 height: 2,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                     colors: [
//                       AppColors.colorFFd1b037,
//                       AppColors.colorFFd1b037.withOpacity(0),
//                     ],
//                   ),
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
