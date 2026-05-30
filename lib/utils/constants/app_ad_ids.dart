import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

abstract final class AppAdIds {
  static const String _bannerAndroidTest =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _bannerIosTest = 'ca-app-pub-3940256099942544/2934735716';
  static const String _bannerAndroidProd =
      'ca-app-pub-7811045286351257/4722728690';
  static const String _bannerIosProd = 'ca-app-pub-SUBSTITUIR/SUBSTITUIR';

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? _bannerAndroidTest : _bannerIosTest;
    }
    return Platform.isAndroid ? _bannerAndroidProd : _bannerIosProd;
  }
}
