import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/flavors/build_config.dart';
import 'app/flavors/env_config.dart';
import 'app/flavors/environment.dart';
import 'app/my_app.dart';
import 'app/core/config/app_bloc_observer.dart';
Future<void> main() async {
  Bloc.observer = AppBlocObserver();

  EnvConfig devConfig = EnvConfig(
    appName: "Ai là triệu phú?",
    appVersion: "0.1",
    apiBaseUrl: "http://millionairedev.mumesoft.com",
    webBaseUrl: "",
    shouldCollectCrashLog: true,
    iOSAppId: '',
    androidAppId: '',
  );

  BuildConfig.instantiate(
    envType: Environment.LOCAL,
    envConfig: devConfig,
  );

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}
