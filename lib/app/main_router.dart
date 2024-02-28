import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'app_routes.dart';
import 'data/model/questions_model_hive.dart';
import 'data/model/user.dart';
import 'modules/login/cubit/login_cubit.dart';
import 'modules/login/views/login_view.dart';
import 'modules/no_internet_page/no_internet_page.dart';
import 'modules/play_game/views/play_again_view.dart';
import 'modules/play_game/views/play_game_view.dart';
import 'modules/ranhking/view/ranking_view.dart';
import 'modules/store/view/store_view.dart';
part 'main_router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: LoginView, path: Routes.login, initial: true),
    MaterialRoute(page: PlayGameView, path: Routes.playGame),
    MaterialRoute(page: PlayAgainView, path: Routes.playAgain),
    MaterialRoute(page: RankingView, path: Routes.ranking),
    MaterialRoute(page: StoreView, path: Routes.ranking),
    MaterialRoute(page: NoInternetPage, path: Routes.noInternet),
  ],
)
class MainRouter extends _$MainRouter {
  MainRouter({
    GlobalKey<NavigatorState>? navigatorKey,
  }) : super(navigatorKey);
}
