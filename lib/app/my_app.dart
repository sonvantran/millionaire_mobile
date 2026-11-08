import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_ads/sky_ads.dart';
import 'core/services/ads_manager.dart';
import 'route_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent
    //         //color set to purple or set your own color
    //         ));
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          home: child,
        );
      },
      child: const RouteApp(),
    );
  }
}
