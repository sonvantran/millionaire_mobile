import '../../flavors/build_config.dart';
import '../../flavors/environment.dart';

class AdsManager {
  static final environment = BuildConfig.instance.environment;
  static String get bannerAdUnitId {
    if (environment == Environment.DEVELOPMENT) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return 'ca-app-pub-9696384850738948/1988867578';
    }
  }

  static String get interstitialAdUnitId {
    if (environment == Environment.DEVELOPMENT) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      return 'ca-app-pub-9696384850738948/2367505434';
    }
  }

  static String get rewardedAdUnitId {
    if (environment == Environment.DEVELOPMENT) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      return 'ca-app-pub-9696384850738948/7654904404';
    }
  }

  static String get rewardedAdUnitId2 {
    if (environment == Environment.DEVELOPMENT) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      return 'ca-app-pub-9696384850738948/7154101051';
    }
  }
}
