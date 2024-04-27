import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/analytics/route_aware_analytics.dart';
import '../../../core/services/ads_manager.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/question_box.dart';
import '../../../core/values/custom_color.dart';
import '../../../core/values/show_message_internal.dart';
import '../../../core/values/text_styles.dart';
import '../../../core/widgets/appBar/custom_appbar.dart';
import '../../../core/widgets/avatar/avatar.dart';
import '../../../core/widgets/popup/popup_notice.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/popup/popup_primary.dart';
import '../../../data/local_saver/question_level.dart';
import '../../../data/model/questions_model_hive.dart';
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
    if (!mounted) return;
    Connectivity().onConnectivityChanged.listen((result) {
      if (!mounted) return;
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi &&
          result != ConnectivityResult.ethernet) {
        if (!context.mounted) return;
        setState(() => isAppConnection = false);
        SkyAds.instance.isAdDisable = true;
        ShowMessageInternal.showMessage("Không có Internet!");
        // context.pushRoute(const NoInternetPageRoute());
      } else {
        if (!context.mounted) return;
        setState(() => isAppConnection = true);
        SkyAds.instance.isAdDisable = false;
        context.read<LoginCubit>().login();
      }
    });
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (!mounted) return;
    if (result != ConnectivityResult.mobile &&
        result != ConnectivityResult.wifi &&
        result != ConnectivityResult.ethernet) {
      if (!context.mounted) return;
      setState(() => isAppConnection = false);
      // context.pushRoute(const NoInternetPageRoute());
      SkyAds.instance.isAdDisable = true;
      ShowMessageInternal.showMessage("Không có Internet!");
    } else {
      if (!context.mounted) return;
      SkyAds.instance.isAdDisable = false;
      setState(() => isAppConnection = true);
    }
  }

  bool isAppConnection = true;

  bool isAppHiden = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cubit = context.read<LoginCubit>();
    if (state == AppLifecycleState.resumed) {
      if (isAppHiden) {
        if (!isAppConnection) return;
        if (!mounted || !context.mounted) return;
        SkyAds.instance.showAppOpenAd(
          placement: AdsId.adsOpenApp,
          forceShow: true,
          context: context,
        );
      }
      isAppHiden = false;
    } else if (state == AppLifecycleState.hidden) {
      isAppHiden = true;
      MessagingService().scheduleMessage();
    }
    if (!cubit.state.isMuteCheckAgain) {
      cubit.setIsMute(isAppHiden);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    originCubit?.dispose();
    super.dispose();
  }

  LoginCubit? originCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.message != current.message,
          listener: (context, state) {
            if (state.message != null) {
              ShowMessageInternal.showMessage(state.message ?? '');
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
        originCubit ??= cubit;
        final question = QuestionBox.getQuestions();
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomAppBar(
                      top: 24.h,
                      leading:
                          state.user != null ? Avatar(user: state.user!) : null,
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
                          onTap: () => playGame(
                            context,
                            cubit,
                            state,
                            question,
                          ),
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
                                ShowMessageInternal.showMessage(
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
                                  ShowMessageInternal.showMessage(
                                      "Vui lòng thử lại sau!");
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
                const SkyBannerAnchorAdWidget(placement: AdsId.bannerHome),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool canPlay = true;
  void playGame(BuildContext context, LoginCubit cubit, LoginState state,
      List<QuestionModelHive> questions) async {
    if (!canPlay) return;
    canPlay = false;
    final checkQuestion = await checkHasQuestion();
    canPlay = true;
    if (!mounted) return;
    if (!checkQuestion) {
      cubit.callQuestionAgain();
      ShowMessageInternal.showMessage("Vui lòng chờ tải bộ câu hỏi!");
      return;
    }
    AnalyticsManager.sendAnalyticsEvent('The_user_want_to_play_game');

    if (state.hasDataLocal) {
      if (state.user == null) {
        ShowMessageInternal.showMessage("Hệ thống tạm thời không tính điểm");
      }
      await context.pushRoute(PlayGameViewRoute(
        isMute: state.isMute,
        mc: state.chooseMC,
        user: state.user,
        questionModelHive: questions[0],
        cubit: cubit,
      ));
      return;
    }
    if (state.hasUser) {
      if (state.user == null) {
        ShowMessageInternal.showMessage("Hệ thống tạm thời không tính điểm");
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
            textButton: 'ĐÓNG',
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
