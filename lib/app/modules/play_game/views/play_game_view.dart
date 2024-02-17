import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sky_ads/banner_anchor_ad_widget.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/extension/integer_extension.dart';
import '../../../core/services/ads_manager.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widgets/popup/popup_notice.dart';
import '../../../core/widgets/popup/popup_play_again.dart';
import '../../../data/local_saver/question_level.dart';
import '../../../data/model/questions_model_hive.dart';
import '../../../data/model/user.dart';
import '../../../main_router.dart';
import '../../login/cubit/login_cubit.dart';
import '../../login/cubit/login_state.dart';
import '../cubit/play_game_cubit.dart';
import '../cubit/play_game_state.dart';
import '../repository/play_game_repository.dart';
import '../widget/answer_item.dart';
import '../widget/app_bar_item.dart';
import '../widget/chart_help.dart';
import '../widget/donghanh.dart';
import '../widget/help_item.dart';
import '../widget/game_point.dart';
import '../widget/point_item.dart';
import '../widget/question.dart';
import '../widget/time_count.dart';

class PlayGameView extends StatefulWidget {
  const PlayGameView(
      {super.key,
      required this.mc,
      required this.isMute,
      this.questionModelHive,
      required this.cubit,
      required this.user});

  final int mc;
  final bool isMute;
  final User? user;
  final QuestionModelHive? questionModelHive;
  final LoginCubit cubit;

  @override
  State<PlayGameView> createState() => _PlayGameViewState();
}

class _PlayGameViewState extends State<PlayGameView> with RouteAwareAnalytics {
  @override
  TrackingScreenViewType get route => TrackingScreenViewType.playGame;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PlayGameCubit(
            context.read<PlayGameRepository>(),
            widget.mc,
            widget.isMute,
            widget.user,
          )..init(widget.questionModelHive),
        ),
        BlocProvider.value(value: widget.cubit),
      ],
      child: PlayGamePage(
        mc: widget.mc,
        isMute: widget.isMute,
        cubit: widget.cubit,
        user: widget.user,
      ),
    );
  }
}

class PlayGamePage extends StatefulWidget {
  const PlayGamePage(
      {super.key,
      required this.mc,
      required this.isMute,
      this.questionModelHive,
      required this.cubit,
      required this.user});

  final int mc;
  final bool isMute;
  final QuestionModelHive? questionModelHive;
  final LoginCubit cubit;
  final User? user;

  @override
  State<PlayGamePage> createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // BannerAd? _bannerAd;
  // bool isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  bool isInterstitialAdLoaded = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _loadInterstitialAd();
    // createBannerAd();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<LoginCubit>();
    final cubit1 = context.read<PlayGameCubit>();
    if (!cubit.state.isMuteCheckAgain) {
      cubit1.setIsMute(isMute: state != AppLifecycleState.resumed);
      cubit.setIsMute(state != AppLifecycleState.resumed);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _bannerAd?.dispose();
    _interstitialAd?.dispose();
    // isBannerAdReady = false;
    isInterstitialAdLoaded = false;
    // final cubit = context.read<PlayGameCubit>();
    // cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context1) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) => previous.user != current.user,
          listener: (context, state) {
            context.read<LoginCubit>().setUser(state.user!);
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) =>
              previous.isShowInstruction != current.isShowInstruction,
          listener: (context, state) {
            if (state.isShowInstruction) {
              _showRole(context, () {
                Navigator.of(context).pop();
                context.read<PlayGameCubit>().setShowInstruction(false);
              });
            } else {
              context.read<PlayGameCubit>().init2(widget.questionModelHive);
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => previous.isMute != current.isMute,
          listener: (context, state) {
            if (state.isMute) {
              context.read<LoginCubit>().stopAudio();
            } else {
              context.read<LoginCubit>().playAudio();
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) =>
              previous.saveDone != current.saveDone && current.saveDone,
          listener: (context, state) async {
            // final cubit = context.read<PlayGameCubit>();
            if (state.timeCounter == 0) {
              int level = 0;
              if (state.level >= 0 && state.level <= 5) {
                level = 0;
              } else if (state.level >= 6 && state.level <= 10) {
                level = 5;
              } else {
                level = 10;
              }
              final point = getQuestionByLevel(level, state.chooseMC);
              if (_interstitialAd != null && isInterstitialAdLoaded) {
                await _interstitialAd?.show();
              }
              // ignore: use_build_context_synchronously
              await context.router.replace(PlayAgainViewRoute(
                caseResult: 0,
                point: point,
                isMute: widget.isMute,
                mc: widget.mc,
                cubit: widget.cubit,
                user: state.user,
              ));
            } else if (state.isFalse) {
              int level = 0;
              if (state.level >= 0 && state.level <= 5) {
                level = 0;
              } else if (state.level >= 6 && state.level <= 10) {
                level = 5;
              } else {
                level = 10;
              }
              final point = getQuestionByLevel(level, state.chooseMC);
              Future.delayed(const Duration(milliseconds: 1500), () async {
                int randomValue = Random().nextInt(5);
                if (_interstitialAd != null &&
                    isInterstitialAdLoaded &&
                    randomValue == 2) {
                  await _interstitialAd?.show();
                }
                // ignore: use_build_context_synchronously
                await context.router.replace(PlayAgainViewRoute(
                    caseResult: 1,
                    point: point,
                    isMute: widget.isMute,
                    mc: widget.mc,
                    cubit: widget.cubit,
                    user: state.user));
              });
            } else if (state.isWin) {
              final point = getQuestionByLevel(state.level, state.chooseMC);
              await context.router.replace(PlayAgainViewRoute(
                caseResult: 2,
                point: point,
                isMute: widget.isMute,
                mc: widget.mc,
                user: state.user,
                cubit: widget.cubit,
              ));
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) =>
              current.timeCounter < 3 &&
              previous.timeCounter != current.timeCounter,
          listener: (context, state) {
            final cubit = context.read<PlayGameCubit>();
            if (state.timeCounter == 0) {
              cubit.outTime();
              context1.read<LoginCubit>().clearQuestionLocal();
            }
            //_showPlayAgain(context, 0);
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listener: (context, state) {
            if (state.isShowGameResult) {
              _key.currentState!.openEndDrawer();
            } else {
              _key.currentState!.closeEndDrawer();
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) =>
              previous.isFalse != current.isFalse,
          listener: (context, state) {
            if (state.isFalse) {
              context1.read<LoginCubit>().clearQuestionLocal();
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) => previous.isWin != current.isWin,
          listener: (context, state) async {
            if (state.isWin) {
              context.read<PlayGameCubit>().win();
              context1.read<LoginCubit>().clearQuestionLocal();
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) => previous.isCall != current.isCall,
          listener: (context, state) async {
            if (!state.isCall) {
              final rightAnswer =
                  state.questions[state.level - 1].rightAnswer ?? 1;
              await _showCallHelp(
                  context, rightAnswer, context.read<PlayGameCubit>());
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) =>
              previous.isChart != current.isChart,
          listener: (context, state) async {
            if (!state.isChart) {
              if (state.chooseMC == 0) {
                final systemSound = await VolumeController().getVolume();
                Future.delayed(
                    Duration(
                        seconds: state.isMute || systemSound <= 0.1 ? 2 : 10),
                    () async {
                  await _showAudienceHelp(
                      context,
                      state.questions[state.level - 1].rightAnswer ?? 1,
                      context.read<PlayGameCubit>(),
                      0);
                });
              } else {
                await _showAudienceHelp(
                    context,
                    state.questions[state.level - 1].rightAnswer ?? 1,
                    context.read<PlayGameCubit>(),
                    state.chooseMC);
              }
            }
          },
        ),
        BlocListener<PlayGameCubit, PlayGameState>(
          listenWhen: (previous, current) =>
              previous.isConsultant != current.isConsultant,
          listener: (context, state) {
            if (!state.isConsultant) {
              Future.delayed(const Duration(seconds: 3), () async {
                await _showConsultantHelp(
                    context,
                    state.questions[state.level - 1].rightAnswer ?? 1,
                    context.read<PlayGameCubit>());
              });
            }
          },
        ),
      ],
      child:
          BlocBuilder<PlayGameCubit, PlayGameState>(builder: (context, state) {
        final cubit = context.read<PlayGameCubit>();
        final checkExpireAnswer = !state.isChooseA &&
            !state.isChooseB &&
            !state.isChooseC &&
            !state.isChooseD &&
            !state.isTrueA &&
            !state.isTrueB &&
            !state.isTrueC &&
            !state.isTrueD &&
            state.isAccessAnswer;
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            context.read<PlayGameCubit>().quesionStop();
            _showPlaycConfirm(context,
                getQuestionByLevel(state.level - 1, state.chooseMC), cubit);
          },
          child: Scaffold(
            key: _key,
            endDrawer: GamePoint(level: state.level, mc: state.chooseMC),
            onEndDrawerChanged: (isOpened) {
              if (state.isShowGameResult != isOpened) {
                cubit.openGameResult(isOpened);
              }
            },
            body: Builder(builder: (context) {
              return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBarItem(
                            onTap: () {
                              context.read<PlayGameCubit>().quesionStop();
                              _showPlaycConfirm(
                                  context,
                                  getQuestionByLevel(
                                      state.level - 1, state.chooseMC),
                                  cubit);
                            },
                            isCheck: false,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: const Icon(
                              Icons.assignment_return_outlined,
                              size: 32,
                              color: AppColors.colorFFFFFFFF,
                            ),
                          ),
                          BlocSelector<LoginCubit, LoginState, bool>(
                              selector: (state) => state.isMute,
                              builder: (contextLogin, isMute) {
                                return InkWell(
                                  onTap: () {
                                    contextLogin
                                        .read<LoginCubit>()
                                        .setIsMute(!isMute);
                                    contextLogin
                                        .read<LoginCubit>()
                                        .setIsMuteCheckAgain(!isMute);
                                    cubit.setIsMute();
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.colorFF77dbe5,
                                            width: 2),
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColors.colorFF57B9FB,
                                            AppColors.colorFF03456e,
                                            AppColors.colorFF57B9FB,
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        !state.isMute
                                            ? Icons.volume_up_rounded
                                            : Icons.volume_off,
                                        color: AppColors.colorFFFFFFFF,
                                      )),
                                );
                              }),
                          AppBarItem(
                            onTap: () => cubit.openGameResult(true),
                            isCheck: true,
                            child: Text(
                              "${state.level} / 15",
                              style: TextStyles.mediumMWhiteS20,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              color: AppColors.colorFFd1b037,
                              height: 2,
                            ),
                          ),
                          PointItem(
                            text:
                                '${getQuestionByLevel(state.level, state.chooseMC)} đ',
                          ),
                          Expanded(
                            child: Container(
                              color: AppColors.colorFFd1b037,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: SizedBox.shrink()),
                          TimeCount(
                            text: state.timeCounter.toString(),
                            isLoading: state.isLoading,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _showRole(context, null);
                              },
                              child: const Stack(
                                children: [
                                  SpinKitPulse(
                                    color: AppColors.colorFFf78f2b,
                                    duration: Duration(seconds: 4),
                                  ),
                                  Positioned.fill(
                                      child: Icon(
                                    Icons.info_outline,
                                    color: AppColors.colorFFFFFFFF,
                                  ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Question(
                            text: !state.isLoading
                                ? state.questions[state.level - 1].question ??
                                    ''
                                : state.startCounter?.toString() ?? '',
                          ),
                          AnswerItem(
                            checkExpire: checkExpireAnswer,
                            isHide: state.isHideA || state.isLoading,
                            isChoose: state.isChooseA,
                            isTrue: state.isTrueA,
                            onTap: () => cubit.chooseAnswer(
                                'A',
                                state.questions[state.level - 1].rightAnswer ??
                                    1),
                            text: !state.isLoading
                                ? (state.questions[state.level - 1]
                                        .answers?[0] ??
                                    '')
                                : '',
                            type: 'A',
                          ),
                          AnswerItem(
                            checkExpire: checkExpireAnswer,
                            isHide: state.isHideB || state.isLoading,
                            isChoose: state.isChooseB,
                            isTrue: state.isTrueB,
                            onTap: () => cubit.chooseAnswer(
                                'B',
                                state.questions[state.level - 1].rightAnswer ??
                                    1),
                            text: !state.isLoading
                                ? (state.questions[state.level - 1]
                                        .answers?[1] ??
                                    '')
                                : '',
                            type: 'B',
                          ),
                          AnswerItem(
                            checkExpire: checkExpireAnswer,
                            isHide: state.isHideC || state.isLoading,
                            isChoose: state.isChooseC,
                            isTrue: state.isTrueC,
                            onTap: () => cubit.chooseAnswer(
                                'C',
                                state.questions[state.level - 1].rightAnswer ??
                                    1),
                            text: !state.isLoading
                                ? (state.questions[state.level - 1]
                                        .answers?[2] ??
                                    '')
                                : '',
                            type: 'C',
                          ),
                          AnswerItem(
                            checkExpire: checkExpireAnswer,
                            isHide: state.isHideD || state.isLoading,
                            isChoose: state.isChooseD,
                            isTrue: state.isTrueD,
                            onTap: () => cubit.chooseAnswer(
                                'D',
                                state.questions[state.level - 1].rightAnswer ??
                                    1),
                            text: !state.isLoading
                                ? (state.questions[state.level - 1]
                                        .answers?[3] ??
                                    '')
                                : '',
                            type: 'D',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HelpItem(
                            checkExpire:
                                state.isDelete2Answers && state.isAccessAnswer,
                            isHide: state.isDelete2Answers,
                            onTap: () => cubit.delete2Answers(
                                state.questions[state.level - 1].rightAnswer ??
                                    1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            child: const Text(
                              "50 : 50",
                              style: TextStyles.mediumWhiteS16,
                            ),
                          ),
                          HelpItem(
                            checkExpire: state.isCall && state.isAccessAnswer,
                            isHide: state.isCall,
                            onTap: () => cubit.call(
                                state.questions[state.level - 1].rightAnswer ??
                                    1),
                            child: const Icon(
                              Icons.phone_in_talk_outlined,
                              color: AppColors.colorFFFFFFFF,
                            ),
                          ),
                          HelpItem(
                            checkExpire:
                                state.isConsultant && state.isAccessAnswer,
                            isHide: state.isConsultant,
                            onTap: () => cubit.consultant(),
                            padding: const EdgeInsets.all(4),
                            child: SizedBox(
                                width: 32,
                                child: Image.asset(
                                  state.chooseMC == 0
                                      ? 'assets/images/ic_team_person.png'
                                      : 'assets/images/dh.png',
                                  color: AppColors.colorFFFFFFFF,
                                )),
                          ),
                          HelpItem(
                            checkExpire: state.isChart && state.isAccessAnswer,
                            isHide: state.isChart,
                            onTap: () => cubit.chart(),
                            child: Icon(
                              // Icons.bar_chart_outlined,
                              state.chooseMC == 0
                                  ? Icons.bar_chart_outlined
                                  : Icons.person_add,
                              color: AppColors.colorFFFFFFFF,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ));
            }),
            bottomSheet: const SkyBannerAnchorAdWidget(),
          ),
        );
      }),
    );
  }

  Future<void> _showAudienceHelp(
      BuildContext context, int answer, PlayGameCubit cubit, int mc) async {
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return BlocProvider.value(
          value: cubit,
          child: PopupNotice(
            textButton: 'ĐÓNG',
            title:
                mc == 0 ? 'HỎI Ý KIẾN\nKHÁN GIẢ' : 'HỎI Ý KIẾN\nBẠN ĐỒNG HÀNH',
            content: mc == 0
                ? ChartHelp(rightAnswer: answer)
                : DongHanh(rightAnswer: answer),
          ),
        );
      },
    );
  }

  Future<void> _showConsultantHelp(
      BuildContext context, int answer, PlayGameCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        List<int> answers = [
          answer,
          answer,
          answer,
          answer,
          answer,
          answer > 2 ? answer - 1 : answer + 1
        ];
        List<int> ntt = [1, 2, 3, 4, 5, 6];
        ntt.shuffle();
        return BlocProvider.value(
          value: cubit,
          child: PopupNotice(
            textButton: 'ĐÓNG',
            title: cubit.state.chooseMC == 0
                ? 'TỔ TƯ VẪN TẠI CHỖ'
                : 'CÁC NHÀ THÔNG THÁI',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                cubit.state.chooseMC == 0
                    ? ConsultantItem(
                        answer: answers[Random().nextInt(6)],
                        asset: 'superman',
                      )
                    : ConsultantItem(
                        answer: answers[Random().nextInt(6)],
                        asset: ntt[0].toString(),
                        check: true,
                      ),
                cubit.state.chooseMC == 0
                    ? ConsultantItem(
                        answer: answers[Random().nextInt(6)],
                        asset: 'deadpool',
                      )
                    : ConsultantItem(
                        answer: answers[Random().nextInt(6)],
                        asset: ntt[1].toString(),
                        check: true,
                      ),
                if (cubit.state.chooseMC == 0)
                  ConsultantItem(
                    answer: answers[Random().nextInt(6)],
                    asset: 'spiderman',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCallHelp(
      BuildContext context, int answer, PlayGameCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        final rd = Random().nextInt(6) + 1;
        double len = MediaQuery.of(context).size.width * 0.5;
        return BlocProvider.value(
          value: cubit,
          child: PopupNotice(
            textButton: 'ĐÓNG',
            titleWidget: BlocSelector<PlayGameCubit, PlayGameState, bool>(
                selector: (state) => state.isShowCall,
                builder: (context, showCall) {
                  return Container(
                    width: showCall ? len : null,
                    height: showCall ? len : null,
                    margin: const EdgeInsets.only(top: 18),
                    padding: showCall ? null : const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorFF5A8AAA,
                      image: showCall
                          ? DecorationImage(
                              fit: BoxFit.contain,
                              image:
                                  AssetImage('assets/images/call_help/$rd.png'),
                            )
                          : null,
                    ),
                    child: showCall
                        ? null
                        : const Icon(
                            Icons.call,
                            color: AppColors.colorFFFFFFFF,
                            size: 80,
                          ),
                  );
                }),
            content: BlocSelector<PlayGameCubit, PlayGameState, bool>(
                selector: (state) => state.isShowCall,
                builder: (context, showCall) {
                  return showCall
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Tôi chắc chắn đáp án chính xác cuối cùng là:',
                              style: TextStyles.regularWhiteS20,
                            ),
                            Text(
                              answer.intToAnswer(),
                              style: TextStyles.boldRedS40,
                            )
                          ],
                        )
                      : const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SpinKitThreeBounce(
                              color: AppColors.colorFF5A8AAA,
                              duration: Duration(milliseconds: 2000),
                              size: 70,
                            ),
                          ],
                        );
                }),
          ),
        );
      },
    );
  }

  Future<void> _showPlaycConfirm(
      BuildContext context, String point, PlayGameCubit cubit) async {
    await showDialog(
        context: context,
        builder: (_) {
          return PopupPlayConfirm(
            onTap: () async {
              cubit.updatePoint(point);
              if (_interstitialAd != null && isInterstitialAdLoaded) {
                await _interstitialAd?.show();
              }
              // ignore: use_build_context_synchronously
              await context.router.replace(PlayAgainViewRoute(
                caseResult: 1,
                point: point,
                isMute: widget.isMute,
                mc: widget.mc,
                user: cubit.state.user,
                cubit: widget.cubit,
              ));
            },
            title: 'Bạn chắc chắn muốn thoát?',
            titleButton1: 'Tiếp tục',
          );
        });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdsManager.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // _moveToHome();
              debugPrint("dsadasdsassss");
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose;
              debugPrint('Ad failed to show: $error');
            },
            onAdClicked: (ad) => AnalyticsManager.logAdImpression(),
          );

          setState(() {
            _interstitialAd = ad;
            isInterstitialAdLoaded = true;
          });
        },
        onAdFailedToLoad: (err) {
          if (dem == 5) return;
          dem++;
          _loadInterstitialAd();
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  int dem = 0;

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
}

String getQuestionByLevel(int level, int mc) {
  final list = List.from(QuestionLevel.questionPoints(mc));
  for (final item in list) {
    if (item.level == level) return item.point;
  }
  return '0';
}

void _showRole(BuildContext context, void Function()? onTap) async {
  const String text = '''
🎮 **Chào mừng đến với Ai Là Triệu Phú!**

Trong trò chơi này, bạn sẽ phải vượt qua ba mốc quan trọng tại các câu hỏi thứ 5, 10 và 15 để giành được phần thưởng lớn.

📜 **Luật chơi:**
- 🎯 Trả lời đúng để tiến lên các mốc điểm quan trọng.
- 🔄 Trả lời sai, bạn sẽ quay lại các mốc điểm trước đó (0, 5, 10).
- ✅ Trả lời đúng, bạn sẽ tiến lên câu hỏi tiếp theo và có cơ hội giành thêm điểm số.

🛠️ **Lựa chọn trợ giúp:**
- 🔍 "50:50": Loại bỏ hai phương án sai.
- 📞 Điện thoại cho người thân để nhờ họ giúp đỡ.
- 🙋 Hỏi ý kiến từ khán giả trường quay để lấy ý kiến đa số.
- 🧠 Tổ tư vấn từ MC Lại Văn Sâm để nhận được sự tư vấn từ một chuyên gia.
- 🤝 Nhận ý kiến từ bạn đồng hành và các chuyên gia khi đối diện với MC Phan Đăng và MC Giáo Sư Xoay. Các ý kiến này có thể giúp bạn đưa ra quyết định đúng đắn hơn khi trả lời câu hỏi.

🏆 **Khi dừng lại:**
Khi bạn dừng lại trong cuộc chơi, điểm số của bạn sẽ được bảo toàn.

💡 **Chúc bạn may mắn và thành công trong cuộc phiêu lưu trí tuệ này!**
''';
  await showDialog(
    context: context,
    builder: (BuildContext _) {
      return PopupNotice(
        isCountDown: false,
        textButton: onTap == null ? "ĐÓNG" : 'SẴN SÀNG',
        title: "LUẬT CHƠI",
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyles.regularWhiteS16,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        onTap: onTap,
      );
    },
  );
}
