import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garrib_app/data/models/product_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ProductModel> _favoriteItems = [];

  List<ProductModel> get favoriteItems => _favoriteItems;

  FavoritesProvider() {
    _loadFavoritesFromPrefs();
  }

  bool isFavorite(ProductModel product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }


  void toggleFavorite(ProductModel product) {
    final isExist = isFavorite(product);
    if (isExist) {
      _favoriteItems.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteItems.add(product);
    }
    _saveFavoritesToPrefs();
    notifyListeners();
  }

  void removeFromFavorites(ProductModel product) {
    _favoriteItems.removeWhere((item) => item.id == product.id);
    _saveFavoritesToPrefs();
    notifyListeners();
  }


  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsMap =
        _favoriteItems.map((item) => item.toMap()).toList();

    await prefs.setString('favorite_items_data', jsonEncode(itemsMap));
  }

  Future<void> _loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('favorite_items_data');

    if (jsonString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        _favoriteItems.clear();

        for (var item in decodedList) {
          final productMap = Map<String, dynamic>.from(item);
          final productId = productMap['id']?.toString() ?? '';
          final product = ProductModel.fromMap(productMap, productId);

          _favoriteItems.add(product);
        }
        notifyListeners();
      } catch (e) {
        debugPrint("Error loading favorites from prefs: $e");
      }
    }
  }
}