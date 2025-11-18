import 'dart:io';
import 'package:flutter/foundation.dart';

String get platformType {
  if (kIsWeb) return "web";
  if (Platform.isAndroid) return "android";
  if (Platform.isIOS) return "ios";
  return "unknown";
}
