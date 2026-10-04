import 'package:flutter/foundation.dart';

class ProductSizeOption {
  final String sizeLabel;
  final double price;

  const ProductSizeOption({
    required this.sizeLabel,
    required this.price,
  });

  factory ProductSizeOption.fromMap(Map<String, dynamic> map) {
    num? parsedPrice;

    if (map['price'] is num) {
      parsedPrice = map['price'];
    } else if (map['price'] is String) {
      parsedPrice = num.tryParse(map['price']);
    }

    return ProductSizeOption(
      sizeLabel: map['sizeLabel']?.toString() ?? '',
      price: parsedPrice?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sizeLabel': sizeLabel,
      'price': price,
    };
  }
}

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> images;
  final bool hasSamples;
  final List<ProductSizeOption> sizes;
  final bool isNewArrival;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.images,
    required this.hasSamples,
    required this.sizes,
    required this.isNewArrival,
  });

  factory ProductModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    try {
      List<String> parsedImages = [];

      if (map['images'] != null && map['images'] is List) {
        parsedImages = (map['images'] as List)
            .map((e) => e?.toString().trim() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (map['images'] is String &&
          (map['images'] as String).isNotEmpty) {
        parsedImages = [(map['images'] as String).trim()];
      }

      List<ProductSizeOption> parsedSizes = [];

      if (map['sizes'] != null && map['sizes'] is List) {
        for (var item in (map['sizes'] as List)) {
          if (item != null) {
            parsedSizes.add(
              ProductSizeOption.fromMap(
                Map<String, dynamic>.from(item as Map),
              ),
            );
          }
        }
      }

      return ProductModel(
        id: docId,
        name: map['name']?.toString() ?? '',
        category: map['category']?.toString() ?? '',
        description: map['description']?.toString() ??
            map['desc']?.toString() ??
            '',
        images: parsedImages,
        hasSamples: map['hasSamples'] is bool
            ? map['hasSamples']
            : false,
        sizes: parsedSizes,
        isNewArrival: map['isNewArrival'] is bool
            ? map['isNewArrival']
            : false,
      );
    } catch (e) {
      debugPrint(
        "Error parsing Product ID: $docId | Error: $e",
      );

      return ProductModel(
        id: docId,
        name: map['name']?.toString() ?? '',
        category: map['category']?.toString() ?? '',
        description: map['description']?.toString() ?? '',
        images: [],
        hasSamples: false,
        sizes: [],
        isNewArrival: false,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'images': images,
      'hasSamples': hasSamples,
      'sizes': sizes.map((size) => size.toMap()).toList(),
      'isNewArrival': isNewArrival,
    };
  }
}