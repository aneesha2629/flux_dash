import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_constants.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLayoutType(String type) async {
    await _prefs?.setString(AppConstants.prefLayoutType, type);
  }

  static String getLayoutType() {
    return _prefs?.getString(AppConstants.prefLayoutType) ?? 'grid';
  }

  static Future<void> saveCardOrder(List<String> ids) async {
    await _prefs?.setString(AppConstants.prefCardOrder, jsonEncode(ids));
  }

  static List<String>? getCardOrder() {
    final raw = _prefs?.getString(AppConstants.prefCardOrder);
    if (raw == null) return null;
    return List<String>.from(jsonDecode(raw));
  }
}
