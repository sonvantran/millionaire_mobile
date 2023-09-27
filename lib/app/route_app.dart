import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/analytics/analytics_manager.dart';
import 'core/values/app_theme.dart';
import 'main_router.dart';
import 'modules/login/api/login_api.dart';
import 'modules/login/repository/login_repository.dart';
import 'modules/play_game/api/play_game_api.dart';
import 'modules/play_game/repository/play_game_repository.dart';
import 'modules/ranhking/api/ranking_api.dart';
import 'modules/ranhking/repository/ranking_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class RouteApp extends StatefulWidget {
  const RouteApp({super.key});

  @override
  State<RouteApp> createState() => _RouteAppState();
}

class _RouteAppState extends State<RouteApp> {
  @override
  void initState() {
    super.initState();
    _appRouter = MainRouter(
      navigatorKey: navigatorKey,
    );
  }

  late MainRouter _appRouter;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PlayGameRepository>(
          create: (context) => PlayGameRepository(PlayGameApi()),
        ),
        RepositoryProvider<LoginRepository>(
          create: (context) => LoginRepository(LoginApi()),
        ),
        RepositoryProvider<RankingRepository>(
          create: (context) => RankingRepository(RankingApi()),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(
          navigatorObservers: () => [
            AnalyticsManager.observer,
            AutoRouteObserver(),
          ],
        ),
        theme: appTheme,
        localizationsDelegates: const [],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
