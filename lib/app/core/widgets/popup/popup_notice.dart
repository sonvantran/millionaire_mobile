import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:millionaire_mobile/app/core/extension/integer_extension.dart';
import 'package:millionaire_mobile/app/modules/play_game/cubit/play_game_cubit.dart';
import 'package:millionaire_mobile/app/modules/play_game/cubit/play_game_state.dart';
import '../../../modules/play_game/widget/time_count.dart';
import '../../values/text_styles.dart';
import '../../values/app_colors.dart';

class PopupNotice extends StatelessWidget {
  const PopupNotice(
      {super.key,
      this.title,
      required this.textButton,
      this.content,
      this.titleWidget,
      this.isCountDown = true,
      this.closePopup = true,
      this.onTap,
      this.onCall});
  final String? title;
  final Widget? titleWidget;
  final String textButton;
  final Widget? content;
  final bool isCountDown;
  final bool closePopup;
  final VoidCallback? onCall;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          onCall?.call();
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        shadowColor: AppColors.colorFF000000,
        backgroundColor: AppColors.colorFF375193,
        title: title != null
            ? Column(
                children: [
                  if (isCountDown)
                    BlocBuilder<PlayGameCubit, PlayGameState>(
                        builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TimeCount(
                            text: state.timeCounter.toString(),
                            isLoading: true,
                          ),
                          const SizedBox(height: 12)
                        ],
                      );
                    }),
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyles.boldWhiteS24,
                  ),
                ],
              )
            : Column(
                children: [
                  if (isCountDown)
                    BlocBuilder<PlayGameCubit, PlayGameState>(
                        builder: (context, state) {
                      return TimeCount(
                        text: state.timeCounter.toString(),
                        isLoading: true,
                      );
                    }),
                  titleWidget!,
                ],
              ),
        content: content,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          InkWell(
            onTap: onTap ??
                () {
                  if (closePopup) Navigator.of(context).pop();
                },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.colorFF77dbe5, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: AppColors.colorFF03456e,
              ),
              child: Text(
                textButton,
                style: TextStyles.mediumWhiteS16,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultantItem extends StatelessWidget {
  const ConsultantItem({
    super.key,
    required this.asset,
    required this.answer,
    this.check = false,
  });

  final String asset;
  final int answer;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.colorFF1F2A48),
      child: Row(
        children: [
          Container(
            width: 40,
            height: check ? 40 : null,
            padding: check ? const EdgeInsets.all(8) : null,
            decoration: BoxDecoration(
                // shape: check ? BoxShape.circle : BoxShape.rectangle,
                color: AppColors.colorFF375193,
                image: check
                    ? DecorationImage(
                        image: AssetImage("assets/images/ndh/$asset.jpg"),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: check
                ? null
                : Image.asset(
                    'assets/images/$asset.png',
                    fit: BoxFit.fitWidth,
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Tôi chọn\nphương án ${answer.intToAnswer()}",
              style: TextStyles.boldWhiteS20,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class RoleItem extends StatelessWidget {
  const RoleItem(
      {super.key,
      this.iconData,
      required this.text,
      this.textIcon,
      this.isAsset});

  final IconData? iconData;
  final String text;
  final String? textIcon;
  final bool? isAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.colorFF1F2A48),
      child: Row(
        children: [
          textIcon != null
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.colorFF375193,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    textIcon!,
                    style: TextStyles.mediumWhiteS16,
                  ))
              : Container(
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.colorFF375193,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: isAsset == true
                      ? SizedBox(
                          width: 32,
                          child: Image.asset(
                            'assets/images/ic_team_person.png',
                            color: AppColors.colorFFFFFFFF,
                          ))
                      : isAsset == false
                          ? SizedBox(
                              width: 32,
                              child: Image.asset(
                                'assets/images/dh.png',
                                color: AppColors.colorFFFFFFFF,
                              ))
                          : Icon(
                              iconData,
                              color: AppColors.colorFFFFFFFF,
                            )),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyles.mediumWhiteS14,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
