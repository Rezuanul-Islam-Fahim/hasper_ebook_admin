import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  static Future<void> checkStatus() async {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();

    if (connectivityResults.contains(ConnectivityResult.none)) {
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
