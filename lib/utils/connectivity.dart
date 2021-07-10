import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  static Future<void> checkStatus() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      throw ConnectivityException();
    }
  }
}

class ConnectivityException implements Exception {
  @override
  String toString() {
    return 'no-internet';
  }
}
