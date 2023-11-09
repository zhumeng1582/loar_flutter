// @Title:  storage
// @Author: tomodel
// @Update: 2023/3/8 17:41
// @Description:

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences?> getPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<dynamic> save(String key, [dynamic value]) async {
    final prefs = await getPreferences();
    if (value is String) return prefs!.setString(key, value);
    if (value is bool) return prefs!.setBool(key, value);
    if (value is int) return prefs!.setInt(key, value);
    if (value is double) return prefs!.setDouble(key, value);
    if (value is List<String>) return prefs!.setStringList(key, value);
    throw UnimplementedError('Type ${value.runtimeType} not implemented');
  }

  static void saveList(String key, List<dynamic> value) async {
    save(key, json.encode(value));
  }

  static Future<List<dynamic>> loadList(String key) async {
    String? jsonString = await getString(key);

    return json.decode(jsonString ?? "");
  }

  static void saveMap(String key, Map<String, dynamic> value) async {
    save(key, json.encode(value));
  }

  static Future<Map<String, dynamic>> loadMap(String key) async {
    String? jsonString = await getString(key);

    return json.decode(jsonString ?? "");
  }

  static Future<String?> getString(String key) async {
    final prefs = await getPreferences();
    return prefs!.getString(key);
  }


  static Future<bool> remove(String key) async {
    final prefs = await getPreferences();
    return prefs!.remove(key);
  }

  static Future<bool> clear() async {
    final prefs = await getPreferences();
    return prefs!.clear();
  }
}
