import 'package:flutter/material.dart';
import 'package:garrib_app/core/services/firestore_service.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/features/home/view/product_card.dart';
import 'package:garrib_app/features/product_details/view/product_details_screen.dart';
import 'package:garrib_app/search/view/search_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  // UPDATED: categoryName is already here and will be passed to SearchScreen
  final String categoryName;

  final FirestoreService _firestoreService = FirestoreService();

  CategoryProductsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softgrey,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),

                    Text(
                      categoryName,
                      style: AppStyles.heading1,
                    ),

                    _buildCircleButton(
                      icon: Icons.search,

                      // UPDATED: Open SearchScreen and pass the current category
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(
                              categoryName: categoryName,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _firestoreService
                  .streamProductsByCategory(categoryName),

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.terracotta,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading products',
                      style: AppStyles.bodySmall,
                    ),
                  );
                }

                final categoryProducts =
                    snapshot.data ?? [];

                if (categoryProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found in this category',
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount: categoryProducts.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 270,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),

                    itemBuilder: (context, index) {
                      final product =
                          categoryProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(
                                product: product,
                              ),
                            ),
                          );
                        },

                        child: ProductCard(
                          product: product,
                          onAddToCart: () {},
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: AppColors.black,
          size: 18,
        ),
        onPressed: onTap,
      ),
    );
  }
}