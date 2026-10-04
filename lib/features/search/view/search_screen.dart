import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/features/product_details/view/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? categoryName;

  const SearchScreen({
    super.key,
    this.categoryName,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Column(
              children: [
                // Search Bar
                _buildSearchField(),

                const SizedBox(height: 16),

                // Results
                Expanded(
                  child: _searchQuery.trim().isEmpty
                      ? _buildEmptyState()
                      : _buildSearchResults(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search Field

  Widget _buildSearchField() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.terracotta.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: AppStyles.bodyMedium.copyWith(
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Search ...',
          hintStyle: AppStyles.bodyMedium.copyWith(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey[400],
            size: 22,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  // Empty State

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Are you looking for something?',
            textAlign: TextAlign.center,
            style: AppStyles.heading1.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Type something in the search box\nabove',
            textAlign: TextAlign.center,
            style: AppStyles.bodyMedium.copyWith(
              fontSize: 16,
              color: const Color.fromARGB(
                255,
                173,
                173,
                173,
              ),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Search Results

  Widget _buildSearchResults() {
    // Start with all products
    Query productsQuery =
        FirebaseFirestore.instance.collection('products');

    // If category exists, search only inside this category
    if (widget.categoryName != null) {
      productsQuery = productsQuery.where(
        'category',
        isEqualTo: widget.categoryName,
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: productsQuery.snapshots(),

      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: AppStyles.bodyMedium.copyWith(
                color: Colors.grey,
              ),
            ),
          );
        }

        // No products
        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }

        // Search by product name
    

        final filteredDocs =
            snapshot.data!.docs.where((doc) {
          final data =
              doc.data() as Map<String, dynamic>;

          final name =
              (data['name'] ?? '')
                  .toString()
                  .toLowerCase();

          return name.contains(
            _searchQuery.toLowerCase(),
          );
        }).toList();

        // No matching products
        if (filteredDocs.isEmpty) {
          return Center(
            child: Text(
              'No results matching "$_searchQuery"',
              style: AppStyles.bodyMedium.copyWith(
                color: Colors.grey,
              ),
            ),
          );
        }

        // Display Results
        

        return ListView.builder(
          itemCount: filteredDocs.length,

          itemBuilder: (context, index) {
            final doc = filteredDocs[index];

            final product = ProductModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );

            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(
                vertical: 8,
              ),

              // Product Image
              leading: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8),

                child: product.images.isNotEmpty
                    ? Image.network(
                        product.images.first,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                          );
                        },
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                      ),
              ),

              // Product Name
              title: Text(
                product.name,
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Product Price
              subtitle: Text(
                '${product.sizes.isNotEmpty ? product.sizes.first.price : 0} EGP',
                style: TextStyle(
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Open Product Details
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
            );
          },
        );
      },
    );
  }
}
