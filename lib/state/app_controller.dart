import 'package:flutter/foundation.dart';

import '../data/mock_drinks.dart';
import '../models/app_user.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import '../models/drink_option.dart';
import '../services/local_storage_services.dart';

class AppController extends ChangeNotifier {
  AppController._(this._storage);

  final LocalStorageService _storage;
  final List<Drink> _drinks = List<Drink>.from(mockDrinks);

  AppUser? _user;
  bool _isLoggedIn = false;

  int _selectedTabIndex = 0;
  String _searchQuery = '';
  DrinkCategory? _selectedCategory;

  final Set<String> _favoriteDrinkIds = <String>{};
  final List<CartItem> _cartItems = <CartItem>[];

  static Future<AppController> bootstrap() async {
    final storage = LocalStorageService();
    await storage.init();
    final controller = AppController._(storage);

    controller._user = storage.loadUser();
    controller._isLoggedIn =
        storage.loadLoginStatus() && controller._user != null;

    controller._selectedTabIndex = storage.loadTab();
    controller._searchQuery = storage.loadSearch();
    controller._selectedCategory = drinkCategoryFromSlug(
      storage.loadCategory(),
    );

    controller._favoriteDrinkIds.addAll(storage.loadFavoriteIds());
    controller._cartItems.addAll(controller._loadCartItems());

    return controller;
  }

  // ── Getters ───────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  AppUser? get user => _user;
  int get selectedTabIndex => _selectedTabIndex;
  String get searchQuery => _searchQuery;
  DrinkCategory? get selectedCategory => _selectedCategory;

  List<Drink> get drinks => List<Drink>.unmodifiable(_drinks);
  List<CartItem> get cartItems => List<CartItem>.unmodifiable(_cartItems);
  Set<String> get favoriteDrinkIds =>
      Set<String>.unmodifiable(_favoriteDrinkIds);

  String get firstName {
    final value = _user?.name.trim() ?? '';
    if (value.isEmpty) return 'Гость';
    return value.split(RegExp(r'\s+')).first;
  }

  List<Drink> get filteredDrinks {
    final query = _searchQuery.trim().toLowerCase();
    return _drinks.where((drink) {
      final matchesCategory =
          _selectedCategory == null || drink.category == _selectedCategory;
      final matchesSearch =
          query.isEmpty ||
          drink.name.toLowerCase().contains(query) ||
          drink.description.toLowerCase().contains(query) ||
          drink.category.label.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList()..sort((a, b) {
      final aScore = (a.isPopular ? 1 : 0) + (a.isSeasonal ? 1 : 0);
      final bScore = (b.isPopular ? 1 : 0) + (b.isSeasonal ? 1 : 0);
      return bScore.compareTo(aScore);
    });
  }

  List<Drink> get popularDrinks =>
      _drinks.where((drink) => drink.isPopular).toList();
  List<Drink> get seasonalDrinks =>
      _drinks.where((drink) => drink.isSeasonal).toList();

  int get cartCount =>
      _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  int get cartTotal =>
      _cartItems.fold<int>(0, (sum, item) => sum + item.totalPrice);

  bool isFavorite(String drinkId) => _favoriteDrinkIds.contains(drinkId);

  Drink? drinkById(String id) {
    for (final drink in _drinks) {
      if (drink.id == id) return drink;
    }
    return null;
  }

  List<Drink> get favoriteDrinks {
    final items = _drinks.where((d) => _favoriteDrinkIds.contains(d.id));
    return items.toList()..sort((a, b) {
      if (a.isPopular && !b.isPopular) return -1;
      if (!a.isPopular && b.isPopular) return 1;
      return a.name.compareTo(b.name);
    });
  }

  // ── Auth ──────────────────────────────────────────────
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _user = AppUser(name: name, email: email, password: password);
    _isLoggedIn = true;
    _selectedTabIndex = 0;
    await _storage.saveUser(_user!);
    await _storage.saveLoginStatus(true);
    notifyListeners();
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final storedUser = _storage.loadUser();
    if (storedUser == null) return 'Сначала зарегистрируйтесь.';
    if (storedUser.email.trim().toLowerCase() != email.trim().toLowerCase() ||
        storedUser.password != password) {
      return 'Неверная почта или пароль.';
    }
    _user = storedUser;
    _isLoggedIn = true;
    await _storage.saveLoginStatus(true);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _selectedTabIndex = 0;
    await _storage.saveLoginStatus(false);
    notifyListeners();
  }

  Future<void> deleteProfile() async {
    _user = null;
    _isLoggedIn = false;
    _selectedTabIndex = 0;
    _searchQuery = '';
    _selectedCategory = null;
    _favoriteDrinkIds.clear();
    _cartItems.clear();
    await _storage.clearAll();
    notifyListeners();
  }

  // ── UI state ──────────────────────────────────────────
  void setSelectedTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    _storage.saveTab(index);
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    _storage.saveSearch(value);
    notifyListeners();
  }

  void setSelectedCategory(DrinkCategory? category) {
    _selectedCategory = category;
    _storage.saveCategory(category?.slug);
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _storage.saveSearch('');
    _storage.saveCategory(null);
    notifyListeners();
  }

  void toggleFavorite(String drinkId) {
    if (_favoriteDrinkIds.contains(drinkId)) {
      _favoriteDrinkIds.remove(drinkId);
    } else {
      _favoriteDrinkIds.add(drinkId);
    }
    _storage.saveFavoriteIds(_favoriteDrinkIds);
    notifyListeners();
  }

  // ── Cart ──────────────────────────────────────────────
  Future<void> addToCart(
    Drink drink,
    DrinkOption option, {
    int quantity = 1,
  }) async {
    final index = _cartItems.indexWhere(
      (item) =>
          item.drink.id == drink.id &&
          item.option.size == option.size &&
          item.option.iceLevel == option.iceLevel &&
          item.option.sugarLevel == option.sugarLevel &&
          _sameExtras(item.option.extras, option.extras) &&
          item.option.note.trim() == option.note.trim(),
    );

    if (index >= 0) {
      final current = _cartItems[index];
      _cartItems[index] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      _cartItems.add(
        CartItem(
          drink: drink,
          option: option,
          quantity: quantity < 1 ? 1 : quantity,
        ),
      );
    }
    await _persistCart();
    notifyListeners();
  }

  Future<void> incrementCartItem(int index) async {
    if (index < 0 || index >= _cartItems.length) return;
    final item = _cartItems[index];
    _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    await _persistCart();
    notifyListeners();
  }

  Future<void> decrementCartItem(int index) async {
    if (index < 0 || index >= _cartItems.length) return;
    final item = _cartItems[index];
    if (item.quantity <= 1) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
    }
    await _persistCart();
    notifyListeners();
  }

  Future<void> removeCartItem(int index) async {
    if (index < 0 || index >= _cartItems.length) return;
    _cartItems.removeAt(index);
    await _persistCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _storage.saveCart(<Map<String, dynamic>>[]);
    notifyListeners();
  }

  Future<void> checkout() async {
    await clearCart();
  }

  List<CartItem> _loadCartItems() {
    final rawList = _storage.loadCart();
    final items = <CartItem>[];
    for (final entry in rawList) {
      try {
        final map = Map<String, dynamic>.from(entry as Map);
        final drinkId = map['drinkId'] as String?;
        final drink = drinkById(drinkId ?? '');
        if (drink == null) continue;
        items.add(CartItem.fromMap(map, drink: drink));
      } catch (_) {}
    }
    return items;
  }

  Future<void> _persistCart() async {
    await _storage.saveCart(_cartItems.map((i) => i.toMap()).toList());
  }

  bool _sameExtras(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final copyA = List<String>.from(a)..sort();
    final copyB = List<String>.from(b)..sort();
    for (var i = 0; i < copyA.length; i++) {
      if (copyA[i] != copyB[i]) return false;
    }
    return true;
  }
}
