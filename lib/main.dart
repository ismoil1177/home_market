import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_market/app.dart';
import 'package:home_market/services/dark_mode_db.dart';

import 'firebase_options.dart';

HiveDb hiveDb = HiveDb();
void main() async {
  await HiveDb.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('uz', 'UZ'),
        Locale('ru', 'RU')
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const HomeMarketApp(),
    ),
  );
}
