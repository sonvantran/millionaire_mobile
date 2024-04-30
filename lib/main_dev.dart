import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sky_ads/sky_ads.dart';
import 'app/core/services/ads_manager.dart';
import 'app/core/services/init_helper.dart';
import 'app/core/services/messaging_service.dart';
import 'app/core/services/question_box.dart';
import 'app/core/services/store_box.dart';
import 'app/data/model/item_model.dart';
import 'app/data/model/question.dart';
import 'app/data/model/questions_model_hive.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';
import 'app/my_app.dart';
import 'app/core/config/app_bloc_observer.dart';
import 'main_prod.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  Bloc.observer = AppBlocObserver();

  EnvConfig devConfig = EnvConfig(
    appName: "Ai là triệu phú?",
    appVersion: "0.1",
    apiBaseUrl: "",
    webBaseUrl: "",
    shouldCollectCrashLog: true,
    iOSAppId: '',
    androidAppId: '',
  );
  await dotenv.load(fileName: 'environment_dev.env');
  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  HttpOverrides.global = MyHttpOverrides();
  await Future.delayed(const Duration(milliseconds: 200));
  await Firebase.initializeApp();
  await MessagingService().initNotification();
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);

  Hive.registerAdapter(QuestionModelHiveAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(StoreAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  await QuestionBox.openBox();
  await StoreBox.openBox();
  await InitHelper().initialize();

  SkyAds.instance.initialize(
    AdConstant(
      interstitialId: {
        AdsId.inter: dotenv.env[AdsId.inter] ?? "",
      },
      nativeId: {
        AdsId.nativeRanking: dotenv.env[AdsId.nativeRanking] ?? "",
        AdsId.nativeStoreBottom: dotenv.env[AdsId.nativeStoreBottom] ?? "",
        AdsId.nativeCategory: dotenv.env[AdsId.nativeCategory] ?? "",
      },
      inlineId: {},
      appOpenId: {
        AdsId.adsOpenApp: dotenv.env[AdsId.adsOpenApp] ?? "",
      },
      bannerAnchorId: {
        AdsId.bannerHome: dotenv.env[AdsId.bannerHome] ?? "",
        AdsId.bannerPlay: dotenv.env[AdsId.bannerPlay] ?? "",
        AdsId.bannerPlayAgain: dotenv.env[AdsId.bannerPlayAgain] ?? "",
        AdsId.bannerRanking: dotenv.env[AdsId.bannerRanking] ?? "",
        AdsId.bannerStore: dotenv.env[AdsId.bannerStore] ?? "",
      },
      interstitialOffsetTime: const Duration(seconds: 30),
      appOpenOffsetTime: const Duration(seconds: 30),
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  try {
    await _initFirebaseCrashlytic();
    await _initFirebaseRemoteConfig();
  } catch (e) {
    log(e.toString());
  }

  runApp(const MyApp());
}

Future<void> _initFirebaseRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults(const {
    "isFirstAOA": false,
    'rateShowInter': 5,
    'limitUserByCall': 60,
    'optimizeUser': 90,
    'adsRankingDistance': 10,
    'messageNoti': "",
    'isScheduleMessage': true,
    'storeLabels': "",
    'badword': "",
    'storeNativeRandom': 5,
  });

  await remoteConfig.fetchAndActivate();
}

Future<void> _initFirebaseCrashlytic() async {
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
