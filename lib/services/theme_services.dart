import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class ThemeService {

  //First, we need to install getstorage package like below
  final _box = GetStorage();

  // Second Define key 
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Third Create bool function, and read get storage true or false
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // if true: We change to dark mode
  // if false: We change to light mode
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // Switch ThemeMode by Getx package (Get.changeThemeMode)
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);

    // Save opposite Value to Save in Get Storage
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
