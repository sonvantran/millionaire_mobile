import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:millionaire_game/app/core/extension/integer_extension.dart';
import 'package:sky_ads/banner_anchor_ad_widget.dart';
import 'package:sky_ads/native_ad_widget.dart';
import 'package:sky_ads/sky_ads.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/services/ads_manager.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/show_message_internal.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widgets/appBar/custom_appbar.dart';
import '../../../data/model/user.dart';
import '../cubit/ranking_cubit.dart';
import '../cubit/ranking_state.dart';
import '../repository/ranking_repository.dart';
import '../widget/cup_item.dart';
import '../widget/date_button.dart';
import '../widget/title_ranking.dart';
import '../widget/user_ranking_item.dart';

@RoutePage()
class RankingView extends StatefulWidget {
  const RankingView({super.key, required this.user});

  final User user;

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> with RouteAwareAnalytics {
  @override
  TrackingScreenViewType get route => TrackingScreenViewType.ranking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RankingCubit(context.read<RankingRepository>())..init(widget.user),
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RankingCubit, RankingState>(
          listenWhen: (previous, current) =>
              previous.message != current.message,
          listener: (context, state) {
            if (state.message != null) {
              ShowMessageInternal.showMessage(state.message ?? '');
            }
          },
        ),
      ],
      child: BlocBuilder<RankingCubit, RankingState>(builder: (context, state) {
        final cubit = context.read<RankingCubit>();
        List<User>? users;
        if (!state.filter) {
          users = state.usersday;
        } else {
          users = state.allUser;
        }
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomAppBar(
                  leading: CustomAppbarItem(
                    icon: Icons.arrow_back_outlined,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: 'Bảng xếp hạng',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DateButton(
                      isChoose: !state.filter,
                      onTap: () => cubit.setFilter(false),
                      text: 'Hôm nay',
                    ),
                    DateButton(
                      isChoose: state.filter,
                      onTap: () => cubit.setFilter(true),
                      text: 'Tất cả',
                    ),
                  ],
                ),
                users != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CupItem(
                            asset: 'sliver_cup',
                            name: users.length > 1 ? users[1].name : 'Chưa có',
                            point: users.length > 1
                                ? users[1].point.toPointDisplay()
                                : '0',
                          ),
                          CupItem(
                            // padding: const EdgeInsets.only(bottom: 32),
                            asset: 'gold_cup',
                            name: users.isNotEmpty ? users[0].name : 'Chưa có',
                            point: users.isNotEmpty
                                ? users[0].point.toPointDisplay()
                                : '0',
                          ),
                          CupItem(
                            asset: 'council_cup',
                            name: users.length > 2 ? users[2].name : 'Chưa có',
                            point: users.length > 2
                                ? users[2].point.toPointDisplay()
                                : '0',
                          ),
                        ],
                      )
                    : Center(
                        child: SpinKitCircle(
                          color: AppColors.colorFF77dbe5,
                          size: 100.r,
                        ),
                      ),
                users != null
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.96,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.colorFF6915EE,
                              AppColors.colorFF2a0e5c,
                              AppColors.colorFF6915EE,
                            ],
                          ),
                          border: Border.all(
                              color: AppColors.colorFF77dbe5, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(24.r)),
                        ),
                        child: users.isNotEmpty
                            ? Column(
                                children: [
                                  const TitleRanking(),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: users.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if ((index - 2) %
                                                (FirebaseRemoteConfig.instance
                                                    .getInt(
                                                        'adsRankingDistance')) !=
                                            0) {
                                          return UserRankingItem(
                                            user: users![index],
                                            number: index + 1,
                                          );
                                        } else {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SkyNativeAdWidget(
                                                placement: AdsId.nativeRanking,
                                                size: Random().nextInt(
                                                                FirebaseRemoteConfig
                                                                    .instance
                                                                    .getInt(
                                                                        'storeNativeRandom')) ==
                                                            1 &&
                                                        index != 2
                                                    ? NativeAdSize.medium
                                                    : NativeAdSize.small,
                                              ),
                                              UserRankingItem(
                                                user: users![index],
                                                number: index + 1,
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const TitleRanking(check: false),
                                ],
                              )
                            : Center(
                                child: Text(
                                  "Chơi ngay để vào bảng xếp hạng",
                                  style: TextStyles.regularWhiteS20,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          bottomSheet: const SkyBannerAnchorAdWidget(
            placement: AdsId.bannerRanking,
          ),
        );
      }),
    );
  }
}
