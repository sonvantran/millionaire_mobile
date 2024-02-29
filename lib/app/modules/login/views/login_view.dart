import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/services/question_box.dart';
import '../../../core/values/custom_color.dart';
import '../../../core/values/show_message_internal.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widgets/appBar/custom_appbar.dart';
import '../../../core/widgets/popup/popup_notice.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/popup/popup_primary.dart';
import '../../../data/local_saver/question_level.dart';
import '../../../main_router.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../repository/login_repository.dart';
import '../../../core/widgets/button/second_button.dart';
import '../widgets/icon_button.dart';
import '../widgets/rating_dialog.dart';
import '../widgets/score_user.dart';
import '../widgets/setting.dart';
import 'package:sky_ads/banner_anchor_ad_widget.dart';
import 'package:sky_ads/sky_ads.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with RouteAwareAnalytics {
  @override
  TrackingScreenViewType get route => TrackingScreenViewType.login;

  @override
  void initState() {
    AnalyticsManager.sendAnalyticsEvent('login');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<LoginRepository>())..login(),
      child: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _nameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initConnectionListen();
    super.initState();
  }

  void initConnectionListen() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi &&
          result != ConnectivityResult.ethernet) {
        if (!context.mounted) return;
        setState(() => isAppConnection = false);
        context.pushRoute(const NoInternetPageRoute());
      } else {
        setState(() => isAppConnection = true);
      }
    });
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.mobile &&
        result != ConnectivityResult.wifi &&
        result != ConnectivityResult.ethernet) {
      if (!context.mounted) return;
      setState(() => isAppConnection = false);
      context.pushRoute(const NoInternetPageRoute());
    } else {
      setState(() => isAppConnection = true);
    }
  }

  bool isAppConnection = true;

  bool isAppHiden = false;
  bool isBlock = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<LoginCubit>();
    if (state == AppLifecycleState.resumed) {
      if (isAppHiden) {
        if (!isAppConnection) return;
        EasyLoading.show(status: 'Loading Ads...');
        setState(() => isBlock = true);
        SkyAds.instance.showAppOpenAd(
          forceShow: true,
          onAdDismissedFullScreenContent: () {
            setState(() => isBlock = false);
            EasyLoading.dismiss();
          },
          onAdFailedToLoad: () {
            setState(() => isBlock = false);
            EasyLoading.dismiss();
          },
          onStartLoading: (canShowAd) {
            if (!canShowAd) {
              setState(() => isBlock = false);
              EasyLoading.dismiss();
            }
          },
        );
      }
      Future.delayed(const Duration(seconds: 10), () {
        if (isBlock) {
          setState(() => isBlock = false);
          EasyLoading.dismiss();
        }
      });
      isAppHiden = false;
    } else if (state == AppLifecycleState.hidden) {
      isAppHiden = true;
    }
    if (!cubit.state.isMuteCheckAgain) {
      cubit.setIsMute(state != AppLifecycleState.resumed);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return !_isConnected
    //     ? const NoInternetPage()
    //     :
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.message != current.message,
          listener: (context, state) {
            if (state.message != null) {
              ShowMessageInternal.showOverlay(context, state.message ?? '');
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => previous.user != current.user,
          listener: (context, state) {
            if (state.user != null) {
              AnalyticsManager.setUserId(state.user?.deviceId ?? '');
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => previous.isMute != current.isMute,
          listener: (context, state) async {
            if (state.isMute) {
              context.read<LoginCubit>().stopAudio();
            } else {
              await Future.delayed(const Duration(milliseconds: 500));
              if (!context.mounted) return;
              context.read<LoginCubit>().isBG
                  ? context.read<LoginCubit>().playBG()
                  : context.read<LoginCubit>().playAudio();
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.hasUser != current.hasUser,
          listener: (context, state) async {
            if (!state.hasUser) {
              await _showdialog(context, context.read<LoginCubit>());
            }
          },
        ),
      ],
      child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final question = QuestionBox.getQuestions();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AbsorbPointer(
            absorbing: isBlock,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_login.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAppBar(
                        top: 32.h,
                        title: state.user != null
                            ? state.user!.name
                            : 'Ai là triệu phú',
                        actions: [
                          if (state.user != null)
                            CustomAppbarItem(
                              onPressed: () async {
                                await _showdialogDelete(context, cubit);
                              },
                              icon: Icons.delete,
                            ),
                          if (state.user != null)
                            CustomAppbarItem(
                              onPressed: () async {
                                _nameController.text = state.user?.name ?? '';
                                await _showdialogEdit(context, cubit);
                              },
                              icon: Icons.edit,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 12.w),
                        child: ScoreUser(text: state.user?.point ?? 0),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SpinKitRipple(
                                color: AppColors.colorFFFFFFFF,
                                size: 160.r,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/images/ic_app.png',
                                  width: 160.w,
                                  height: 160.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          SecondButton(
                            gradient: CustomColor.dung,
                            width: MediaQuery.of(context).size.width * 0.70,
                            onTap: () async {
                              final checkQuestion = await checkHasQuestion();
                              if (!context.mounted) return;
                              if (!checkQuestion) {
                                cubit.initQuestion();
                                ShowMessageInternal.showOverlay(
                                    context, "Vui lòng thử lại sau!");
                                return;
                              }
                              AnalyticsManager.sendAnalyticsEvent(
                                  'The_user_want_to_play_game');

                              if (state.hasDataLocal) {
                                if (state.user == null) {
                                  ShowMessageInternal.showOverlay(context,
                                      "Hệ thống tạm thời không tính điểm");
                                }
                                await context.pushRoute(PlayGameViewRoute(
                                  isMute: state.isMute,
                                  mc: state.chooseMC,
                                  user: state.user,
                                  questionModelHive: question[0],
                                  cubit: cubit,
                                ));
                                return;
                              }
                              if (state.hasUser) {
                                if (state.user == null) {
                                  ShowMessageInternal.showOverlay(context,
                                      "Hệ thống tạm thời không tính điểm");
                                }
                                await context.pushRoute(PlayGameViewRoute(
                                  mc: state.chooseMC,
                                  isMute: state.isMute,
                                  user: state.user,
                                  cubit: cubit,
                                ));
                              } else {
                                await _showdialog(context, cubit);
                              }
                            },
                            text: !state.hasDataLocal ? "Bắt đầu" : "Tiếp tục",
                          ),
                          if (state.hasDataLocal)
                            SecondButton(
                              width: MediaQuery.of(context).size.width * 0.55,
                              text: "Chơi lại",
                              onTap: () {
                                AnalyticsManager.sendAnalyticsEvent(
                                    'The_user_want_to_play_game_again');
                                cubit.updatePoint(getQuestionByLevel(
                                    question[0].currentLevel - 1,
                                    state.chooseMC));
                                if (state.user == null) {
                                  ShowMessageInternal.showOverlay(context,
                                      "Hệ thống tạm thời không tính điểm");
                                }
                                context.pushRoute(PlayGameViewRoute(
                                  isMute: state.isMute,
                                  mc: state.chooseMC,
                                  user: state.user,
                                  cubit: cubit,
                                ));
                              },
                            ),
                          Stack(
                            children: [
                              SecondButton(
                                width: MediaQuery.of(context).size.width * 0.55,
                                text: "Cửa hàng",
                                onTap: () {
                                  if (state.user == null) {
                                    ShowMessageInternal.showOverlay(
                                        context, "Vui lòng thử lại sau!");
                                    return;
                                  }
                                  AnalyticsManager.sendAnalyticsEvent(
                                      'The_user_want_to_purchase');
                                  context.pushRoute(StoreViewRoute(
                                      cubit: cubit, user: state.user!));
                                },
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 8.r,
                                  backgroundColor: AppColors.colorFFB20000,
                                ),
                              )
                            ],
                          ),
                          SecondButton(
                            width: MediaQuery.of(context).size.width * 0.55,
                            onTap: () async {
                              AnalyticsManager.sendAnalyticsEvent(
                                  'The_user_want_to_watch_ranking_view');
                              if (state.hasUser && state.user != null) {
                                await context.pushRoute(RankingViewRoute(
                                  user: state.user!,
                                ));
                              } else {
                                await _showdialog(context, cubit);
                              }
                            },
                            text: "Bảng xếp hạng",
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonItem(
                                onTap: () => _showDevelop(context),
                                color: AppColors.colorFF3AA33A,
                                iconData: Icons.developer_mode_sharp,
                              ),
                              const SizedBox(width: 24),
                              ButtonItem(
                                onTap: () => _showSetting(context, cubit),
                                color: AppColors.colorFF375193,
                                iconData: Icons.settings,
                              ),
                              const SizedBox(width: 24),
                              ButtonItem(
                                onTap: () => _showRole(context),
                                color: AppColors.colorFFd1b037,
                                iconData: Icons.info_outline,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonItem(
                                onTap: () {
                                  AnalyticsManager.sendAnalyticsEvent(
                                      'The_user_want_to_review_app');
                                  _showdialogRating(context, cubit);
                                },
                                color: AppColors.colorFFAF4848,
                                iconData: Icons.star,
                              ),
                              const SizedBox(width: 24),
                              ButtonItem(
                                onTap: () => cubit.feedBack(),
                                color: AppColors.colorFF424242,
                                iconData: Icons.rate_review_outlined,
                              ),
                            ],
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
      }),
    );
  }

  Future<void> _showdialog(BuildContext context, LoginCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupPrimary(
          onTap: () {
            Navigator.of(context).pop();
            cubit.updateUser(_nameController.text.trim());
            AnalyticsManager.signUp();
          },
          title: "Bạn hãy điền tên để tiếp tục:",
          titleButton1: 'Tiếp tục',
          textController: _nameController,
          validateName: cubit.state.validateName ?? '',
        );
      },
    );
  }

  Future<void> _showdialogDelete(BuildContext context, LoginCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupPrimary(
          onTap: () {
            Navigator.of(context).pop();
            cubit.deleteUser();
          },
          title: "Bạn có chắc muốn xoá tài khoản?",
          content:
              "Việc này sẽ xoá toàn bộ thông tin tài khoản của bạn và không thể hoàn tác!",
          titleButton1: 'Xác nhận',
          validateName: '',
        );
      },
    );
  }

  Future<void> _showdialogEdit(BuildContext context, LoginCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupPrimary(
          onTap: () {
            Navigator.of(context).pop();
            cubit.updateUser(_nameController.text.trim());
          },
          title: "Bạn hãy điền tên để tiếp tục:",
          titleButton1: 'Tiếp tục',
          textController: _nameController,
          validateName: cubit.state.validateName ?? '',
        );
      },
    );
  }

  void _showSetting(BuildContext context, LoginCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return BlocProvider.value(
          value: cubit,
          child: const PopupNotice(
            isCountDown: false,
            textButton: 'CANCEL',
            title: 'CÀI ĐẶT',
            content: Setting(),
          ),
        );
      },
    );
  }

  Future<void> _showdialogRating(BuildContext context, LoginCubit cubit) async {
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return RatingPopup(
          onPressed: () => cubit.reviewApp(),
        );
      },
    );
  }

  void _showRole(BuildContext context) async {
    const String text = '''
Người chơi được cung cấp bốn lựa chọn trợ giúp: "50:50", điện thoại cho người thân, khán giả trường quay và tổ tư vấn từ MC Lại Văn Sâm; cũng như ý kiến từ bạn đồng hành và các chuyên gia khi đối diện với MC Phan Đăng và MC Giáo Sư Xoay.
''';
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return PopupNotice(
          isCountDown: false,
          textButton: 'ĐÓNG',
          title: "LUẬT CHƠI",
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyles.regularWhiteS12,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12.h),
                const RoleItem(
                  text: '🎯Loại 2 phương án sai',
                  textIcon: '50 : 50',
                ),
                const RoleItem(
                  text: '📞Gọi điện cho người thân',
                  iconData: Icons.phone_in_talk_outlined,
                ),
                const RoleItem(
                  text: '🙋Tổ tư vấn tại chỗ',
                  isAsset: true,
                ),
                const RoleItem(
                  text: '🧠Trợ giúp khán giả trong trường quay',
                  iconData: Icons.bar_chart_outlined,
                ),
                const RoleItem(
                  text: '🤝Hỏi ý kiến bạn đồng hành',
                  iconData: Icons.person_add,
                ),
                const RoleItem(
                  text: '💡Hỏi ý kiến những nhà thông thái',
                  isAsset: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDevelop(BuildContext context) async {
    const content = '''
🎮 Trò chơi này dựa trên "Ai là Triệu Phú" và nhằm mang đến giây phút giải trí, lưu ý rằng tiền trong trò chơi không có giá trị thực tế.
💡Chúng tôi hy vọng bạn thích và tận hưởng trò chơi.
''';
    await showDialog(
      context: context,
      builder: (BuildContext _) {
        return PopupNotice(
          isCountDown: false,
          textButton: 'ĐÓNG',
          title: "ĐIỀU KHOẢN",
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    content,
                    style: TextStyles.regularWhiteS18,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.colorFF77dbe5, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: AppColors.colorFF03456e,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Được phát triển bởi:',
                        style: TextStyles.boldWhiteS20,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'PCT Innovations\nthiepcong12@gmail.com',
                        style: TextStyles.mediumWhiteS14,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String getQuestionByLevel(int level, int mc) {
  final list = List.from(QuestionLevel.questionPoints(mc));
  for (final item in list) {
    if (item.level == level) return item.point;
  }
  return '0';
}
