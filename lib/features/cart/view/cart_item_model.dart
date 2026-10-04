import 'package:garrib_app/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String selectedSize;
  final double price;
  int quantity;

  CartItemModel({
    required this.product,
    required this.selectedSize,
    required this.price,
    this.quantity = 1,
  });
}