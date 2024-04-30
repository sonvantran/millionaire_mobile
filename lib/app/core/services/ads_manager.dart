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

abstract class AdsId {
  static const String adsOpenApp = 'app_open_ads';

  static const String nativeRanking = 'native_raking';
  static const String nativeStoreBottom = 'native_store_bottom';
  static const String nativeCategory = 'native_category';

  static const String inter= 'inter';

  static const String bannerHome = 'banner_home';
  static const String bannerRanking = 'banner_ranking';
  static const String bannerPlay = 'banner_play';
  static const String bannerPlayAgain = 'banner_play_again';
  static const String bannerStore = 'banner_store';

  static const String rewardPlayGame = 'reward_play_game';
  static const String rewardPlayAgain = 'reward_play_again';
}
