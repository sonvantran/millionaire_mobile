import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
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
    apiBaseUrl: "http://millionaire.mumesoft.com",
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

  MobileAds.instance.initialize();

  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}
