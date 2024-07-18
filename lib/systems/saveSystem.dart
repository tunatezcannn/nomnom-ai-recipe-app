import 'package:nomnom/systems/recipeClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferenceManager {
  static SharedPreferences? _preferences;

  static Future initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static String getString(String key, [String defaultValue = ""]) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  static Future setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  static Future setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  static int getInt(String key, [int defaultValue = 0]) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  static Future setDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  static double getDouble(String key, [double defaultValue = 0.0]) {
    return _preferences?.getDouble(key) ?? defaultValue;
  }

  static Future setList(String key, List<String> value) async {
    String encodedData = json.encode(value);
    await _preferences?.setString(key, encodedData);
  }

  static List<String> getList(String key) {
    String? encodedData = _preferences?.getString(key);
    if (encodedData != null) {
      try {
        return List<String>.from(json.decode(encodedData));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  static Future setDateTime(String key, DateTime value) async {
    await _preferences?.setInt(key, value.millisecondsSinceEpoch);
  }

  static DateTime getDateTime(String key) {
    int? milliseconds = _preferences?.getInt(key);
    if (milliseconds != null) {
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }
    return DateTime.now();
  }
  
  static Set<String> getAllKeys() {
    return _preferences?.getKeys() ?? {};
  }

  static Future setFavoriteRecipe(List<Recipe> recipes) async {
    String favList = jsonEncode(recipes);
    _preferences?.setString('favoriteRecipes', favList);
  }

  static List<Recipe> getFavoriteRecipes() {
    Set<String> allKeys = _preferences!.getKeys();
    if(allKeys.contains('favoriteRecipes') == false) {
      return [];
    }

    String? favList = _preferences?.getString('favoriteRecipes');
    var decoded =  json.decode(favList!);
    List<Recipe> recipes = [];
    for (var recipe in decoded) {
      recipes.add(Recipe.fromJson(recipe));
    }
    return recipes;
  }
}
