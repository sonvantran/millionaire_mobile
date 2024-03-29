import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsManager {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static Future<void> trackingViewScreen(TrackingScreenViewType screen) {
    return analytics.setCurrentScreen(
        screenName: screen.screenName, screenClassOverride: screen.screenClass);
  }

  static Future<void> sendAnalyticsEvent(String name) async {
    await analytics.logEvent(
      name: name,
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true.toString(),
      },
    );

    // debugPrint('log event: $name');
  }

  static Future<void> setUserId(String id) async {
    await analytics.setUserId(id: id);
    await login();
    // debugPrint('set userId and login succeeded');
  }

  static Future<void> login() async {
    await analytics.logLogin(loginMethod: 'device_id');
  }

  static Future<void> signUp() async {
    await analytics.logSignUp(signUpMethod: 'fill_name');
  }

  static Future<void> share(
      String method, String itemId, String contentType) async {
    await analytics.logShare(
        method: method, itemId: itemId, contentType: contentType);
  }

  static Future<void> postScore(int score, int? level) async {
    await analytics.logPostScore(score: score, level: level);
  }

  static Future<void> logAdImpression() async {
    await analytics.logAdImpression(
      adPlatform: Platform.isAndroid ? 'android' : 'ios',
      adSource: 'google admob',
    );
  }
}

enum TrackingScreenViewType { login, playGame, playAgain, ranking, store }

extension TrackingScreenViewTypeX on TrackingScreenViewType {
  String get screenName {
    switch (this) {
      case TrackingScreenViewType.login:
        return 'login';
      case TrackingScreenViewType.playGame:
        return 'play_game';
      case TrackingScreenViewType.playAgain:
        return 'play_again';
      case TrackingScreenViewType.ranking:
        return 'ranking';
      case TrackingScreenViewType.store:
        return "store";
    }
  }

  String get screenClass {
    switch (this) {
      case TrackingScreenViewType.login:
        return 'LoginView';
      case TrackingScreenViewType.playGame:
        return 'PlayGameView';
      case TrackingScreenViewType.playAgain:
        return 'PlayAgainView';
      case TrackingScreenViewType.ranking:
        return 'RankingView';
      case TrackingScreenViewType.store:
        return 'StoreView';
    }
  }
}
