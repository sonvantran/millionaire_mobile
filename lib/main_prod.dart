import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sky_ads/sky_ads.dart';
import 'app/core/services/init_helper.dart';
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
    envType: Environment.PRODUCTION,
    envConfig: devConfig,
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);

  Hive.registerAdapter(QuestionModelHiveAdapter());
  Hive.registerAdapter(QuestionAdapter());
  await QuestionBox.openBox();
  await InitHelper().initialize();
  SkyAds.instance.initialize(
    AdConstant(
      interstitialId: 'ca-app-pub-9696384850738948/2367505434',
      nativeId: 'ca-app-pub-9696384850738948/3539865110',
      inlineId: 'ca-app-pub-3940256099942544/9214589741',
      appOpenId: 'ca-app-pub-9696384850738948/1097480706',
      bannerAnchorId: 'ca-app-pub-9696384850738948/1988867578',
      interstitialOffsetTime: const Duration(seconds: 30),
      appOpenOffsetTime: const Duration(seconds: 30),
    ),
  );

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}
