import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class DeviceStorage {
  // -----------------------------------------
  // basic non-secure storage
  // -----------------------------------------
  static Future<bool> deleteAll() async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.clear();
    return true;
  }

  static Future<bool> deleteKey(String key) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.remove(key);
    return true;
  }

  static Future<String> getValue(String key) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    return _storage.getString(key);
  }

  static Future<int> getInt(String key) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    return _storage.getInt(key);
  }

  static Future<bool> getBool(String key) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    return _storage.getBool(key) ?? false;
  }

  static Future<bool> setInt(String key, int value) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.setInt(key, value);
    return true;
  }

  static Future<bool> setBool(String key, bool value) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.setBool(key, value);
    return true;
  }

  static Future<bool> setValue(String key, String value) async {
    final SharedPreferences _storage = await SharedPreferences.getInstance();
    await _storage.setString(key, value);
    return true;
  }

  // -----------------------------------------
  // user prefs
  // -----------------------------------------
  static Future<String> getVerificationId() async {
    String val = await getValue("tryb_verification_id");
    return val;
  }

  static Future<bool> setVerificationId(String value) async {
    return await setValue("tryb_verification_id", value);
  }

  static Future<bool> deleteVerificationId() async {
    return await deleteKey("tryb_verification_id");
  }
}
