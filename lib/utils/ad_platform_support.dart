import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class AdPlatformSupport {
  AdPlatformSupport._();

  static bool get isSupported => !kIsWeb && Platform.isAndroid;
}
