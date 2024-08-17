// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'main_router.dart';

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginView();
    },
  );
}

/// generated route for
/// [PlayAgainView]
class PlayAgainRoute extends PageRouteInfo<PlayAgainRouteArgs> {
  PlayAgainRoute({
    Key? key,
    required int caseResult,
    required String point,
    required int mc,
    required bool isMute,
    required LoginCubit cubit,
    required User? user,
    List<PageRouteInfo>? children,
  }) : super(
          PlayAgainRoute.name,
          args: PlayAgainRouteArgs(
            key: key,
            caseResult: caseResult,
            point: point,
            mc: mc,
            isMute: isMute,
            cubit: cubit,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'PlayAgainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlayAgainRouteArgs>();
      return PlayAgainView(
        key: args.key,
        caseResult: args.caseResult,
        point: args.point,
        mc: args.mc,
        isMute: args.isMute,
        cubit: args.cubit,
        user: args.user,
      );
    },
  );
}

class PlayAgainRouteArgs {
  const PlayAgainRouteArgs({
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
    return 'PlayAgainRouteArgs{key: $key, caseResult: $caseResult, point: $point, mc: $mc, isMute: $isMute, cubit: $cubit, user: $user}';
  }
}

/// generated route for
/// [PlayGameView]
class PlayGameRoute extends PageRouteInfo<PlayGameRouteArgs> {
  PlayGameRoute({
    Key? key,
    required int mc,
    required bool isMute,
    QuestionModelHive? questionModelHive,
    required LoginCubit cubit,
    required User? user,
    List<PageRouteInfo>? children,
  }) : super(
          PlayGameRoute.name,
          args: PlayGameRouteArgs(
            key: key,
            mc: mc,
            isMute: isMute,
            questionModelHive: questionModelHive,
            cubit: cubit,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'PlayGameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlayGameRouteArgs>();
      return PlayGameView(
        key: args.key,
        mc: args.mc,
        isMute: args.isMute,
        questionModelHive: args.questionModelHive,
        cubit: args.cubit,
        user: args.user,
      );
    },
  );
}

class PlayGameRouteArgs {
  const PlayGameRouteArgs({
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
    return 'PlayGameRouteArgs{key: $key, mc: $mc, isMute: $isMute, questionModelHive: $questionModelHive, cubit: $cubit, user: $user}';
  }
}

/// generated route for
/// [RankingView]
class RankingRoute extends PageRouteInfo<RankingRouteArgs> {
  RankingRoute({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          RankingRoute.name,
          args: RankingRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'RankingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RankingRouteArgs>();
      return RankingView(
        key: args.key,
        user: args.user,
      );
    },
  );
}

class RankingRouteArgs {
  const RankingRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'RankingRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [StoreView]
class StoreRoute extends PageRouteInfo<StoreRouteArgs> {
  StoreRoute({
    Key? key,
    required User user,
    required LoginCubit cubit,
    List<PageRouteInfo>? children,
  }) : super(
          StoreRoute.name,
          args: StoreRouteArgs(
            key: key,
            user: user,
            cubit: cubit,
          ),
          initialChildren: children,
        );

  static const String name = 'StoreRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StoreRouteArgs>();
      return StoreView(
        key: args.key,
        user: args.user,
        cubit: args.cubit,
      );
    },
  );
}

class StoreRouteArgs {
  const StoreRouteArgs({
    this.key,
    required this.user,
    required this.cubit,
  });

  final Key? key;

  final User user;

  final LoginCubit cubit;

  @override
  String toString() {
    return 'StoreRouteArgs{key: $key, user: $user, cubit: $cubit}';
  }
}
