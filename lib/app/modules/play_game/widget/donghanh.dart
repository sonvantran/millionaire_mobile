import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:millionaire_mobile/app/core/extension/integer_extension.dart';

import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../cubit/play_game_cubit.dart';
import '../cubit/play_game_state.dart';

class DongHanh extends StatefulWidget {
  const DongHanh({super.key, required this.rightAnswer});
  final int rightAnswer;

  @override
  State<DongHanh> createState() => _DongHanhState();
}

class _DongHanhState extends State<DongHanh> {
  bool isLoading = false;
  String asset = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayGameCubit, PlayGameState>(builder: (context, state) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.chooseDh == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Item(i: 1, textStyle: TextStyles.regularWhiteS12),
                          Item(i: 2, textStyle: TextStyles.regularWhiteS12),
                          Item(i: 4, textStyle: TextStyles.regularWhiteS12),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Item(i: 3, textStyle: TextStyles.regularWhiteS12),
                          Item(i: 5, textStyle: TextStyles.regularWhiteS12),
                          Item(i: 6, textStyle: TextStyles.regularWhiteS12),
                        ],
                      ),
                    ],
                  )
                : Item(
                    i: state.chooseDh!,
                    height: 100,
                    width: 100,
                    textStyle: TextStyles.boldWhiteS24,
                  ),
            state.chooseDh == null
                ? Text(
                    "Hãy chọn bạn đồng hành của bạn!",
                    style: TextStyles.regularWhiteS18,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tôi chắc chắn đáp án chính xác cuối cùng là:',
                        style: TextStyles.regularWhiteS20,
                      ),
                      state.loadingDh
                          ? const SpinKitPouringHourGlassRefined(
                              color: AppColors.colorFF57B9FB,
                              duration: Duration(milliseconds: 1000),
                              size: 60,
                            )
                          : Text(
                              widget.rightAnswer.intToAnswer(),
                              style: TextStyles.boldRedS40,
                            ),
                    ],
                  )
          ],
        ),
      );
    });
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.i,
    this.onTap,
    this.width = 60,
    this.height = 60,
    required this.textStyle,
  });
  final int i;

  final Function()? onTap;
  final double width;
  final double height;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final String name = i.intToNdh();
    return BlocBuilder<PlayGameCubit, PlayGameState>(builder: (context, state) {
      final cubit = context.read<PlayGameCubit>();
      return InkWell(
        onTap: () {
          cubit.chooseDh(i);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/dong_hanh/$i.jpg'),
                ),
              ),
            ),
            Text(
              name,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12)
          ],
        ),
      );
    });
  }
}
