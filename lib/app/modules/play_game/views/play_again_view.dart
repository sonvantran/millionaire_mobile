import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../../../data/local_saver/sound_manager.dart';
import '../../../data/model/user.dart';
import '../../../main_router.dart';
import '../../login/cubit/login_cubit.dart';
import '../../login/widgets/rating_dialog.dart';

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
  final User? user;
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
    chiatay();
    if (mounted) {
      Future.delayed(const Duration(seconds: 1),
          () => _showdialogRating(context, widget.cubit));
      Future.delayed(const Duration(seconds: 2), () => widget.cubit.playBG());
    }
    super.initState();
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    _rewardedAd?.dispose();
    // isBannerAdReady = false;
    isRewardAdReady = false;
    if (player.playing) {
      player.stop();
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit..clearQuestionLocal(),
      child: _buildPage(context),
    );
  }

  final AudioPlayer player = AudioPlayer();
  String soundPath(String name) => 'assets/audios/$name.mp3';
  void chiatay() async {
    try {
      final assetSource = soundPath(widget.isMute
          ? SoundManager.muteSound
          : SoundManager.chiatay(widget.mc)[Random().nextInt(2)]);
      await player.setAsset(assetSource);
      await player.play();
    } catch (e) {
      rethrow;
    }
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
                  onPressed: () => context.router.pop(),
                ),
                title: "Ai là triệu phú",
                top: 32,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                            Text(
                              'Bạn sẽ ra về với phần thưởng:',
                              style: TextStyles.mediumMWhiteS24,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${widget.point} điểm',
                              style: TextStyles.mediumMWhiteS24,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Chúc bạn may mắn lần sau!',
                              style: TextStyles.mediumMWhiteS24,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            AdsButton(
                              icon: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
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
                                      widget.cubit.updatePoint(score <= 20000000
                                          ? widget.point
                                          : "20.000.000");
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
                                      context, "Vui lòng thử lại sau");
                                }
                              },
                              text:
                                  "Xem Video Để ${score <= 20000000 ? 'X2 Điểm' : "+20.000.000 đ"}",
                            ),
                            SizedBox(height: 20.h),
                            SecondButton(
                              width: MediaQuery.of(context).size.width * 0.55,
                              onTap: () => context.router.pop(),
                              text: 'Menu',
                            ),
                            SizedBox(height: 20.h),
                            SecondButton(
                              width: MediaQuery.of(context).size.width * 0.55,
                              onTap: () async => await _share(context),
                              text: 'Chia sẻ',
                            ),
                            SizedBox(height: 20.h),
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
              ),
              const SkyBannerAnchorAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdsManager.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (!mounted) return;
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
              debugPrint('Ad failed to show: $error');
            },
          );
          if (!mounted) return;
          setState(() {
            _rewardedAd = ad;
            isRewardAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          if (dem >= 5) return;
          dem++;
          _loadRewardedAd();
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  int dem = 0;

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
      await Share.shareFiles(
        [qrImageFile.path],
        subject:
            'Tải ứng dụng trên cửa hàng: https://play.google.com/store/apps/dev?id=5241296680413671492',
        text:
            'Tải ứng dụng trên cửa hàng: https://play.google.com/store/apps/dev?id=5241296680413671492',
      );
      await AnalyticsManager.share('share', '1 item', 'contentType');
    } catch (e) {
      rethrow;
    }
  }

  void _showdialogRating(BuildContext context, LoginCubit cubit) async {
    final pre = await SharedPreferences.getInstance();
    final isRating = pre.getBool("isRating") ?? false;
    if (isRating || !context.mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return RatingPopup(
          onPressed: () {
            cubit.reviewApp();
            pre.setBool("isRating", true);
          },
        );
      },
    );
  }
}
