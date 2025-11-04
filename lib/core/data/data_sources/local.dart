import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../constants/local_keys.dart';
import '../../helpers/json_helper.dart';
import '../models/user_model.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await prefs!.setString(key, value);
    if (value is int) return await prefs!.setInt(key, value);
    if (value is bool) return await prefs!.setBool(key, value);

    return await prefs!.setDouble(key, value);
  }

  // في ملف LocalStorage.dart
  static dynamic getData({
    required String key,
  }) {
    // ⚠️ استبدل prefs!.get(key) بـ prefs?.get(key) ?? null
    // أو قم بالتحقق الأولي
    if (prefs == null) {
      // يمكنك طباعة رسالة تحذير هنا للمساعدة في Debugging
      debugPrint("Error: SharedPreferences not initialized!");
      return null;
    }
    return prefs!.get(key);
  }


  static Future<void> delete(String key) async {
    prefs!.remove(key);
  }

  static Future<void> clearData() async {
    await prefs!.clear();
  }

  static Future<void> saveObject(dynamic object, String key) async {
    String itemToSave = JsonHelper.convertObjectToString(object);
    prefs!.setString(key, itemToSave);
  }

  static Future<void> saveListOfObject(
      List<dynamic> objects, String key) async {
    List<String> listToSave =
        JsonHelper.convertListOfObjectsToListOfString(objects);
    prefs!.setStringList(key, listToSave);
  }

  static Future<List<String>> getListOfString(String key) async {
    return prefs!.getStringList(key) ?? [];
  }

  static UserModel? getUser() {
    final String? userString = prefs!.getString(LocalKeys.user);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    } else {
      return null;
    }
  }

}
