import 'dart:io';

import 'package:flutter/widgets.dart';

class InterNetProvider extends ChangeNotifier {
  bool _internetCheck = false;
  bool get internetCheck => _internetCheck;

  Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _internetCheck = true;
        print("Internet available : $_internetCheck");
        notifyListeners();
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}