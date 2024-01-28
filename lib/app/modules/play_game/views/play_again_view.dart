import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sky_ads/banner_anchor_ad_widget.dart';
import 'dart:ui' as ui;
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/services/ads_manager.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/show_message_internal.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widgets/appBar/custom_appbar.dart';
import '../../../core/widgets/button/ads_button.dart';
import '../../../core/widgets/button/second_button.dart';
import '../../../data/model/user.dart';
import '../../../main_router.dart';
import '../../login/cubit/login_cubit.dart';

class PlayAgainView extends StatefulWidget {
  const PlayAgainView(
      {super.key,
      required this.caseResult,
      required this.point,
      required this.mc,
      required this.isMute,
      required this.cubit,
      required this.user});

  final int caseResult;
  final String point;
  final int mc;
  final bool isMute;
  final User user;
  final LoginCubit cubit;

  @override
  State<PlayAgainView> createState() => _PlayAgainViewState();
}

class _PlayAgainViewState extends State<PlayAgainView>
    with RouteAwareAnalytics {
  final _key = GlobalKey();
  // BannerAd? _bannerAd;
  // bool isBannerAdReady = false;

  RewardedAd? _rewardedAd;
  bool isRewardAdReady = false;

  @override
  TrackingScreenViewType get route => TrackingScreenViewType.playAgain;

  @override
  void initState() {
    _loadRewardedAd();
    // createBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    _rewardedAd?.dispose();
    // isBannerAdReady = false;
    isRewardAdReady = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit..clearQuestionLocal(),
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final score = int.parse(widget.point.replaceAll('.', ''));
    return Scaffold(
      body: RepaintBoundary(
        key: _key,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nav_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomAppBar(
                leading: CustomAppbarItem(
                    icon: Icons.arrow_back_outlined,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                title: "Ai là triệu phú",
                top: 32,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      // decoration: BoxDecoration(
                      //     color: AppColors.colorFF375193,
                      //     border: Border.all(
                      //         color: AppColors.colorFF03456e, width: 2),
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        children: [
                          Text(
                            widget.caseResult == 0
                                ? 'Đã hết thời gian rồi!'
                                : widget.caseResult == 1
                                    ? 'Rất tiếc!'
                                    : 'Chúc mừng bạn!',
                            style: TextStyles.mediumWhiteS36,
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Bạn sẽ ra về với phần thưởng:',
                            style: TextStyles.mediumMWhiteS24,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${widget.point} điểm',
                            style: TextStyles.mediumMWhiteS24,
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Chúc bạn may mắn lần sau!',
                            style: TextStyles.mediumMWhiteS24,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          AdsButton(
                            icon: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Image.asset(
                                  "assets/images/reward_icon.png",
                                  color: AppColors.colorFF402744,
                                )),
                            onTap: () {
                              if (_rewardedAd != null && isRewardAdReady) {
                                _rewardedAd?.show(
                                  onUserEarnedReward: (_, __) {
                                    widget.cubit.updatePoint(score <= 100000000
                                        ? widget.point
                                        : "100.000.000");
                                    ShowMessageInternal.showOverlay(
                                        context, "Bạn đã thành công");
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () => context.router.pop(),
                                    );
                                  },
                                );
                              } else {
                                ShowMessageInternal.showOverlay(
                                    context, "Đã có lỗi xảy ra");
                              }
                            },
                            text:
                                "Xem Video Để ${score <= 100000000 ? 'X2 Điểm' : "+100.000.000 Đ"}",
                          ),
                          const SizedBox(height: 20),
                          SecondButton(
                            width: MediaQuery.of(context).size.width * 0.55,
                            onTap: () => context.router.pop(),
                            text: 'Menu',
                          ),
                          const SizedBox(height: 20),
                          SecondButton(
                            width: MediaQuery.of(context).size.width * 0.55,
                            onTap: () async => await _share(context),
                            text: 'Chia sẻ',
                          ),
                          const SizedBox(height: 20),
                          SecondButton(
                            width: MediaQuery.of(context).size.width * 0.55,
                            onTap: () {
                              AnalyticsManager.sendAnalyticsEvent(
                                  'The_user_want_to_play_game_again');
                              context.router.replace(PlayGameViewRoute(
                                  mc: widget.mc,
                                  isMute: widget.isMute,
                                  user: widget.user,
                                  cubit: widget.cubit));
                            },
                            text: 'Chơi lại',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: const SkyBannerAnchorAdWidget(),
    );
  }

  // void createBannerAd() {
  //   try {
  //     _bannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: AdsManager.bannerAdUnitId,
  //       listener: BannerAdListener(
  //         onAdLoaded: (ad) {
  //           setState(() {
  //             isBannerAdReady = true;
  //           });
  //         },
  //         onAdFailedToLoad: (ad, err) {
  //           ad.dispose();
  //           debugPrint('Failed to load a banner ad: ${err.message}');
  //         },
  //         onAdOpened: (ad) => debugPrint('Ad opened'),
  //         onAdClosed: (ad) => debugPrint('Ad closed'),
  //         onAdClicked: (ad) => AnalyticsManager.logAdImpression(),
  //       ),
  //       request: const AdRequest(),
  //     )..load();
  //   } catch (e) {
  //     _bannerAd = null;
  //   }
  // }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdsManager.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose;
              debugPrint('Ad failed to show: $error');
            },
          );

          setState(() {
            _rewardedAd = ad;
            isRewardAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  Future<void> _share(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File qrImageFile = File('$tempPath/qrcode.png');
      await qrImageFile.writeAsBytes(pngBytes!);
      // ignore: use_build_context_synchronously
      final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.shareFiles(
        [qrImageFile.path],
        subject:
            'Tải ứng dụng trên cửa hàng: https://play.google.com/store/apps/dev?id=5241296680413671492',
        text:
            'Tải ứng dụng trên cửa hàng: https://play.google.com/store/apps/dev?id=5241296680413671492',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
      await AnalyticsManager.share('share', '1 item', 'contentType');
    } catch (e) {
      rethrow;
    }
  }
}
