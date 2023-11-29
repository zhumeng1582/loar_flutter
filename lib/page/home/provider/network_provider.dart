import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  cancel() {
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {}
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (_connectionStatus == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (_connectionStatus == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (_connectionStatus == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
    } else if (_connectionStatus == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (_connectionStatus == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
    } else if (_connectionStatus == ConnectivityResult.other) {
      // I am connected to a network which is not in the above mentioned networks.
    } else if (_connectionStatus == ConnectivityResult.none) {
      // I am not connected to any network.
    }
    notifyListeners();
  }
}
