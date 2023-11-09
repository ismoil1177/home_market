import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDb {
  static String settings = "settings";
  static Box<bool> boxx = Hive.box(settings);

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(settings)) {
      await Hive.openBox<bool>(settings);
    }
  }

  void storeData(bool isLight) async {
    await boxx.put("isLight", isLight);
  }

  void changeMode() async {
    await boxx.put("isLight", !isLight);
  }

  ThemeMode get mode => isLight ? ThemeMode.dark : ThemeMode.light;

  ValueListenable<Box<bool>> get getListenable => boxx.listenable();

  bool get isLight => ((boxx.get("isLight")) ?? false);
}
