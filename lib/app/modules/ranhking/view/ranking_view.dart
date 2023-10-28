import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/services/ads_manager.dart';
import '../../../core/values/app_colors.dart';
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

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> with RouteAwareAnalytics {
  BannerAd? _bannerAd;
  bool isBannerAdReady = false;
  @override
  TrackingScreenViewType get route => TrackingScreenViewType.ranking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RankingCubit(context.read<RankingRepository>())..init(),
      child: _buildPage(context),
    );
  }

  @override
  void initState() {
    createBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    isBannerAdReady = false;
    super.dispose();
  }

  Widget _buildPage(BuildContext context) {
    return BlocBuilder<RankingCubit, RankingState>(builder: (context, state) {
      final cubit = context.read<RankingCubit>();
      List<User>? users;
      if (state.filter == 0) {
        users = state.usersday;
      } else if (state.filter == 1) {
        users = state.usersMonth;
      } else {
        users = state.usersYear;
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  title: 'Bảng xếp hạng'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DateButton(
                    isChoose: state.filter == 0,
                    onTap: () => cubit.setFilter(0),
                    text: 'Ngày',
                  ),
                  DateButton(
                    isChoose: state.filter == 1,
                    onTap: () => cubit.setFilter(1),
                    text: 'Tháng',
                  ),
                  DateButton(
                    isChoose: state.filter == 2,
                    onTap: () => cubit.setFilter(2),
                    text: 'Năm',
                  )
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
                          point:
                              '${users.length > 1 ? formatNumber(users[1].point) : '0'} đ',
                        ),
                        CupItem(
                          // padding: const EdgeInsets.only(bottom: 32),
                          asset: 'gold_cup',
                          name: users.isNotEmpty ? users[0].name : 'Chưa có',
                          point:
                              '${users.isNotEmpty ? formatNumber(users[0].point) : '0'} đ',
                        ),
                        CupItem(
                          asset: 'council_cup',
                          name: users.length > 2 ? users[2].name : 'Chưa có',
                          point:
                              '${users.length > 2 ? formatNumber(users[2].point) : '0'} đ',
                        ),
                      ],
                    )
                  : const Center(
                      child: SpinKitCircle(
                        color: AppColors.colorFF77dbe5,
                        size: 100,
                      ),
                    ),
              users != null
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: MediaQuery.of(context).size.height * 0.42,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 18, vertical: 12),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                      ),
                      child: users.isNotEmpty
                          ? Column(
                              children: [
                                const TitleRanking(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for (int i = 0; i < users.length; i++)
                                          UserRankingItem(
                                            name: users[i].name,
                                            number: i + 1,
                                            point:
                                                '${formatNumber(users[i].point)} đ',
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                                const TitleRanking(check: false),
                              ],
                            )
                          : const Center(
                              child: Text(
                                "Chơi ngay để vào bảng xếp hạng",
                                style: TextStyles.regularWhiteS20,
                                textAlign: TextAlign.center,
                              ),
                            ),
                    )
                  : SizedBox(height: MediaQuery.of(context).size.height * 0.4)
            ],
          ),
        ),
        bottomNavigationBar: _bannerAd == null || !isBannerAdReady
            ? const SizedBox.shrink()
            : Container(
                height: 52,
                margin: const EdgeInsets.only(bottom: 12),
                child: AdWidget(ad: _bannerAd!),
              ),
      );
    });
  }

  void createBannerAd() {
    try {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdsManager.bannerAdUnitId!,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isBannerAdReady = true;
            });
          },
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
            debugPrint('Failed to load a banner ad: ${err.message}');
          },
          onAdOpened: (ad) => debugPrint('Ad opened'),
          onAdClosed: (ad) => debugPrint('Ad closed'),
          onAdClicked: (ad) => AnalyticsManager.logAdImpression(),
        ),
        request: const AdRequest(),
      )..load();
    } catch (e) {
      _bannerAd = null;
    }
  }

  String formatNumber(int i) {
    String formatted = "";
    String input = i.toString();
    int length = input.length;

    for (int i = length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formatted = '.$formatted';
      }
      formatted = input[i] + formatted;
    }

    return formatted;
  }
}
