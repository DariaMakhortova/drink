import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static const String _loggedInKey = 'is_logged_in';
  static const String _favoritesKey = 'favorite_drinks';
  static const String _cartKey = 'cart_items';
  static const String _tabKey = 'selected_tab';
  static const String _searchKey = 'search_query';
  static const String _categoryKey = 'selected_category';

  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefs => _preferences!;

  // ── User ──────────────────────────────────────────────
  Future<void> saveUser(AppUser user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  AppUser? loadUser() {
    final raw = _prefs.getString(_userKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      return AppUser.fromMap(Map<String, dynamic>.from(decoded as Map));
    } catch (_) {
      return null;
    }
  }

  // ── Login status ──────────────────────────────────────
  Future<void> saveLoginStatus(bool value) async {
    await _prefs.setBool(_loggedInKey, value);
  }

  bool loadLoginStatus() => _prefs.getBool(_loggedInKey) ?? false;

  // ── Favorites ─────────────────────────────────────────
  Future<void> saveFavoriteIds(Iterable<String> ids) async {
    await _prefs.setStringList(_favoritesKey, ids.toList());
  }

  Set<String> loadFavoriteIds() {
    return _prefs.getStringList(_favoritesKey)?.toSet() ?? <String>{};
  }

  // ── Cart ──────────────────────────────────────────────
  Future<void> saveCart(List<Map<String, dynamic>> items) async {
    await _prefs.setString(_cartKey, jsonEncode(items));
  }

  List<dynamic> loadCart() {
    final raw = _prefs.getString(_cartKey);
    if (raw == null || raw.isEmpty) return <dynamic>[];
    try {
      return jsonDecode(raw) as List<dynamic>;
    } catch (_) {
      return <dynamic>[];
    }
  }

  // ── UI state ──────────────────────────────────────────
  Future<void> saveTab(int index) async => await _prefs.setInt(_tabKey, index);
  int loadTab() => _prefs.getInt(_tabKey) ?? 0;

  Future<void> saveSearch(String query) async =>
      await _prefs.setString(_searchKey, query);
  String loadSearch() => _prefs.getString(_searchKey) ?? '';

  Future<void> saveCategory(String? slug) async {
    if (slug == null) {
      await _prefs.remove(_categoryKey);
    } else {
      await _prefs.setString(_categoryKey, slug);
    }
  }

  String? loadCategory() => _prefs.getString(_categoryKey);

  // ── Clear ─────────────────────────────────────────────
  Future<void> clearAll() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_loggedInKey);
    await _prefs.remove(_favoritesKey);
    await _prefs.remove(_cartKey);
    await _prefs.remove(_tabKey);
    await _prefs.remove(_searchKey);
    await _prefs.remove(_categoryKey);
  }
}
