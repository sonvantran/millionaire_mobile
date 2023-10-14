import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInterner {
  static Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
