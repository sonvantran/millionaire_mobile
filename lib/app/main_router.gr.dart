// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'main_router.dart';

class _$MainRouter extends RootStackRouter {
  _$MainRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginViewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginView(),
      );
    },
    PlayGameViewRoute.name: (routeData) {
      final args = routeData.argsAs<PlayGameViewRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: PlayGameView(
          key: args.key,
          mc: args.mc,
          isMute: args.isMute,
          questionModelHive: args.questionModelHive,
          cubit: args.cubit,
          user: args.user,
        ),
      );
    },
    PlayAgainViewRoute.name: (routeData) {
      final args = routeData.argsAs<PlayAgainViewRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: PlayAgainView(
          key: args.key,
          caseResult: args.caseResult,
          point: args.point,
          mc: args.mc,
          isMute: args.isMute,
          cubit: args.cubit,
          user: args.user,
        ),
      );
    },
    RankingViewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RankingView(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'login',
          fullMatch: true,
        ),
        RouteConfig(
          LoginViewRoute.name,
          path: 'login',
        ),
        RouteConfig(
          PlayGameViewRoute.name,
          path: 'play_game',
        ),
        RouteConfig(
          PlayAgainViewRoute.name,
          path: 'play_again',
        ),
        RouteConfig(
          RankingViewRoute.name,
          path: 'ranking',
        ),
      ];
}

/// generated route for
/// [LoginView]
class LoginViewRoute extends PageRouteInfo<void> {
  const LoginViewRoute()
      : super(
          LoginViewRoute.name,
          path: 'login',
        );

  static const String name = 'LoginViewRoute';
}

/// generated route for
/// [PlayGameView]
class PlayGameViewRoute extends PageRouteInfo<PlayGameViewRouteArgs> {
  PlayGameViewRoute({
    Key? key,
    required int mc,
    required bool isMute,
    QuestionModelHive? questionModelHive,
    required LoginCubit cubit,
    required User? user,
  }) : super(
          PlayGameViewRoute.name,
          path: 'play_game',
          args: PlayGameViewRouteArgs(
            key: key,
            mc: mc,
            isMute: isMute,
            questionModelHive: questionModelHive,
            cubit: cubit,
            user: user,
          ),
        );

  static const String name = 'PlayGameViewRoute';
}

class PlayGameViewRouteArgs {
  const PlayGameViewRouteArgs({
    this.key,
    required this.mc,
    required this.isMute,
    this.questionModelHive,
    required this.cubit,
    required this.user,
  });

  final Key? key;

  final int mc;

  final bool isMute;

  final QuestionModelHive? questionModelHive;

  final LoginCubit cubit;

  final User? user;

  @override
  String toString() {
    return 'PlayGameViewRouteArgs{key: $key, mc: $mc, isMute: $isMute, questionModelHive: $questionModelHive, cubit: $cubit, user: $user}';
  }
}

/// generated route for
/// [PlayAgainView]
class PlayAgainViewRoute extends PageRouteInfo<PlayAgainViewRouteArgs> {
  PlayAgainViewRoute({
    Key? key,
    required int caseResult,
    required String point,
    required int mc,
    required bool isMute,
    required LoginCubit cubit,
    required User? user,
  }) : super(
          PlayAgainViewRoute.name,
          path: 'play_again',
          args: PlayAgainViewRouteArgs(
            key: key,
            caseResult: caseResult,
            point: point,
            mc: mc,
            isMute: isMute,
            cubit: cubit,
            user: user,
          ),
        );

  static const String name = 'PlayAgainViewRoute';
}

class PlayAgainViewRouteArgs {
  const PlayAgainViewRouteArgs({
    this.key,
    required this.caseResult,
    required this.point,
    required this.mc,
    required this.isMute,
    required this.cubit,
    required this.user,
  });

  final Key? key;

  final int caseResult;

  final String point;

  final int mc;

  final bool isMute;

  final LoginCubit cubit;

  final User? user;

  @override
  String toString() {
    return 'PlayAgainViewRouteArgs{key: $key, caseResult: $caseResult, point: $point, mc: $mc, isMute: $isMute, cubit: $cubit, user: $user}';
  }
}

/// generated route for
/// [RankingView]
class RankingViewRoute extends PageRouteInfo<void> {
  const RankingViewRoute()
      : super(
          RankingViewRoute.name,
          path: 'ranking',
        );

  static const String name = 'RankingViewRoute';
}
