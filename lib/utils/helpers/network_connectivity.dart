import 'dart:async';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkConnectivity {
  static final StreamController<bool> connectivityController =
  StreamController<bool>.broadcast();

  static bool _isListenerInitialized = false;
  static int connectionChangeCount = 0;
  static bool _wasConnected = false;

  static Future<bool> isNetworkAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    bool isConnected;
    if (connectivityResult is List<ConnectivityResult>) {
      isConnected = !connectivityResult.contains(ConnectivityResult.none);
    } else {
      isConnected = connectivityResult != ConnectivityResult.none;
    }

    connectivityController.add(isConnected);
    return isConnected;
  }

  static void initConnectivityListener() async {
    if (!_isListenerInitialized) {
      _isListenerInitialized = true;

      _wasConnected = await isNetworkAvailable(); // initialize properly

      Connectivity().onConnectivityChanged.listen((results) async {
        debugPrint("🔌 Connectivity changed: $results");

        bool isConnected = results is List<ConnectivityResult>
            ? !results.contains(ConnectivityResult.none)
            : results != ConnectivityResult.none;

        connectivityController.add(isConnected);

        if (_wasConnected && !isConnected) {
          connectionChangeCount++;
          await _runDisconnectedOperations();
        } else if (!_wasConnected && isConnected) {
          connectionChangeCount++;
          await _runConnectedOperations();
        }

        _wasConnected = isConnected;
      });
    }
  }

  static Future<void> _runDisconnectedOperations() async {
    Snackbar.warning("Offline",
        "You are now offline");
  }

  static Future<void> _runConnectedOperations() async {

    Snackbar.success("Online",
      "Connection Restored!");
  }
}
