import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/features/cart/view/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  CartProvider() {
    _loadCartFromPrefs();
  }

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));


  void addToCartFromHome(ProductModel product) {
    final sizeItem = product.sizes.isNotEmpty ? product.sizes.first : null;
    final sizeLabel = sizeItem?.sizeLabel ?? 'Default';
    final price = sizeItem?.price ?? 0.0;

    addToCart(
      product: product,
      selectedSize: sizeLabel,
      price: price,
      quantity: 1,
    );
  }

  void addToCart({
    required ProductModel product,
    required String selectedSize,
    required double price,
    required int quantity,
  }) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == selectedSize,
    );

    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(
        CartItemModel(
          product: product,
          selectedSize: selectedSize,
          price: price,
          quantity: quantity,
        ),
      );
    }

    _saveCartToPrefs(); 
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      _saveCartToPrefs(); 
      notifyListeners();
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0 && index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity = newQuantity;
      _saveCartToPrefs(); 
      notifyListeners();
    }
  }
  
  void clearCart() async {
    _cartItems.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_items_data');
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> itemsMap = _cartItems.map((item) {
      return {
        'product': item.product.toMap(), 
        'selectedSize': item.selectedSize,
        'price': item.price,
        'quantity': item.quantity,
      };
    }).toList();

    await prefs.setString('cart_items_data', jsonEncode(itemsMap));
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('cart_items_data');

    if (jsonString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        _cartItems.clear();

        for (var item in decodedList) {
          if (item['product'] != null) {
            final productMap = Map<String, dynamic>.from(item['product']);
            final productId = productMap['id']?.toString() ?? '';
            final product = ProductModel.fromMap(productMap, productId);

            _cartItems.add(
              CartItemModel(
                product: product,
                selectedSize: item['selectedSize'] ?? '',
                price: (item['price'] as num?)?.toDouble() ?? 0.0,
                quantity: item['quantity'] ?? 1,
              ),
            );
          }
        }
        notifyListeners();
      } catch (e) {
        debugPrint("Error loading cart from prefs: $e");
      }
    }
  }
}