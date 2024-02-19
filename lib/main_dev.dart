import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sky_ads/sky_ads.dart';
import 'app/core/services/init_helper.dart';
import 'app/core/services/messaging_service.dart';
import 'app/core/services/question_box.dart';
import 'app/data/model/question.dart';
import 'app/data/model/questions_model_hive.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';
import 'app/my_app.dart';
import 'app/core/config/app_bloc_observer.dart';

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

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await MessagingService().initNotification();
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);

  Hive.registerAdapter(QuestionModelHiveAdapter());
  Hive.registerAdapter(QuestionAdapter());
  await QuestionBox.openBox();
  await InitHelper().initialize();
  SkyAds.instance.initialize(
    AdConstant(
      interstitialId: 'ca-app-pub-3940256099942544/1033173712',
      nativeId: 'ca-app-pub-3940256099942544/2247696110',
      inlineId: 'ca-app-pub-3940256099942544/9214589741',
      appOpenId: 'ca-app-pub-3940256099942544/9257395921',
      bannerAnchorId: 'ca-app-pub-3940256099942544/6300978111',
      interstitialOffsetTime: const Duration(seconds: 30),
      appOpenOffsetTime: const Duration(seconds: 30),
    ),
  );

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  _initFirebaseRemoteConfig();

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
  });

  await remoteConfig.fetchAndActivate();
}
