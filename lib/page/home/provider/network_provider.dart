import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/im_data.dart';

final networkProvider =
    ChangeNotifierProvider<NetworkNotifier>((ref) => NetworkNotifier());

class NetworkNotifier extends ChangeNotifier {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool isNetwork() {
    return _connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.ethernet;
  }

  initState() {
    _initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  cancel() {
    _connectivitySubscription.cancel();
  }

  Future<void> _initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {}
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.ethernet) {
      GlobeDataManager.instance.isEaseMob = true;
    } else {
      GlobeDataManager.instance.isEaseMob = false;
    }

    notifyListeners();
  }
}
