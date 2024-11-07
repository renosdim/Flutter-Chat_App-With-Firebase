import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  bool hasConnection = false;
  StreamController<bool> connectionChangeController = StreamController<bool>.broadcast();
  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      hasConnection = false;
    } else {
      checkInternet().then((internet) {
        hasConnection = internet;
      });
    }
    connectionChangeController.add(hasConnection);
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      hasConnection = false;
    } else {
      hasConnection = await checkInternet();
    }
    connectionChangeController.add(hasConnection);
    return hasConnection;
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch(_) {
      return true;
    }
  }
}
