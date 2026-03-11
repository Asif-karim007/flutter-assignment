import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/services/storage_service.dart';

class ThemeController extends GetxController {
  ThemeController(this._storageService);

  final StorageService _storageService;

  final RxBool isDarkMode = false.obs;

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadTheme() async {
    isDarkMode.value = _storageService.getSavedThemeMode();
  }

  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;
    await _storageService.saveThemeMode(value);
  }
}
