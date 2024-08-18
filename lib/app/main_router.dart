import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'app_routes.dart';
import 'data/model/questions_model_hive.dart';
import 'data/model/user.dart';
import 'modules/login/cubit/login_cubit.dart';
import 'modules/login/views/login_view.dart';
import 'modules/play_game/views/play_again_view.dart';
import 'modules/play_game/views/play_game_view.dart';
import 'modules/ranhking/view/ranking_view.dart';
import 'modules/store/view/store_view.dart';
part 'main_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page|View,Route')
class MainRouter extends RootStackRouter  {
  MainRouter({
    GlobalKey<NavigatorState>? navigatorKey,
  });

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        MaterialRoute(page: LoginRoute.page, path: Routes.login, initial: true),
        MaterialRoute(page: PlayGameRoute.page, path: Routes.playGame),
        MaterialRoute(page: PlayAgainRoute.page, path: Routes.playAgain),
        MaterialRoute(page: RankingRoute.page, path: Routes.ranking),
        MaterialRoute(page: StoreRoute.page, path: Routes.ranking),
      ];
}
