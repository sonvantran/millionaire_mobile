import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../data/local_saver/mc.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import 'custom_mc.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocSelector<LoginCubit, LoginState, bool>(
            selector: (state) => !state.isMute,
            builder: (context, isNotMute) {
              final cubit = context.read<LoginCubit>();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isNotMute ? Icons.volume_up_rounded : Icons.volume_off,
                        color: AppColors.colorFFFFFFFF,
                      ),
                      SizedBox(width: 8.w),
                      Text("Âm thanh", style: TextStyles.boldWhiteS20),
                    ],
                  ),
                  Switch(
                    inactiveThumbColor: AppColors.colorFFFFFFFF,
                    inactiveTrackColor: AppColors.colorFF424242,
                    value: isNotMute,
                    onChanged: (e) {
                      cubit.setIsMute(!e);
                      cubit.setIsMuteCheckAgain(!e);
                    },
                    activeColor: AppColors.colorFFFFFFFF,
                    activeTrackColor: AppColors.colorFF3AA33A,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              );
            }),
        const SizedBox(height: 16),
        BlocSelector<LoginCubit, LoginState, int>(
            selector: (state) => state.chooseMC,
            builder: (context, chooseMC) {
              final cubit = context.read<LoginCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppColors.colorFFFFFFFF,
                      ),
                      SizedBox(width: 8.w),
                      Text('Chọn MC', style: TextStyles.boldWhiteS20),
                    ],
                  ),
                  SizedBox(height: 16.w),
                  for (final item in MC.listOfMC)
                    CustomMC(
                      title: item.name,
                      value: item.stt,
                      avatar: item.avatar,
                      groupValue: chooseMC,
                      onChanged: (value) {
                        cubit.setChooseMC(value as int);
                      },
                    )
                ],
              );
            })
      ],
    );
  }
}
