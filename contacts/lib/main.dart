import 'dart:io';

import 'package:contacts/ios/ios.app.dart';
import 'package:flutter/material.dart';
import 'android/android.app.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); //garante que hardwares estão ativos
  runApp(
    Platform.isAndroid ? AndroidApp() : IosApp(),
  );
}
