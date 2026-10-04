import 'package:flutter/material.dart';
import 'package:garrib_app/core/services/firestore_service.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/features/category_products/view/category_products_screen.dart';
import 'package:garrib_app/features/home/view/custom_category_card.dart';
import 'package:garrib_app/features/home/view/product_card.dart';
import 'package:garrib_app/features/product_details/view/product_details_screen.dart';
import 'package:garrib_app/features/search/view/search_screen.dart';


class HomeScreen extends StatefulWidget {
  final FirestoreService _firestoreService = FirestoreService();

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<Map<String, String>> categoriesList = [
  {
    'title': 'Perfumes',
    'image': 'assets/images/perfum.png',
  },
  {
    'title': 'Skincare',
    'image': 'assets/images/skincare.png',
  },
  {
    'title': 'Coffee Beans',
    'image': 'assets/images/beans.png',
  },
  {
    'title': 'Oils',
    'image': 'assets/images/oil.png',
  },
  {
    'title': 'Makeup',
    'image': 'assets/images/mackup.png',
  },
  {
    'title': 'Colors',
    'image': 'assets/images/colors.png',
  },
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: Column(
        children: [

          // ================= HEADER =================

          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                ),
              ],
            ),

            child: SafeArea(
              bottom: false,

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 17,
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    SizedBox(
                      width: 30,

                      child: Image.asset(
                        'assets/images/Terracotta _logo.png',
                        width: 18,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        'GARRAB',
                        style: AppStyles.logo,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Container(
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

                        icon: const Icon(
                          Icons.search,
                          color: AppColors.black,
                          size: 20,
                        ),

                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: false,
                          ).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SearchScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= BODY =================

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // ================= BANNER =================

                  SizedBox(
                    height: 223,
                    width: 355,

                    child: Stack(
                      children: [

                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(16),

                            child: Image.asset(
                              'assets/images/banner.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          left: 20,
                          top: 60,

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(
                                'Get 25% OFF',

                                style:
                                    AppStyles.heading1.copyWith(
                                  color: Colors.white,
                                  height: 1.1,
                                  fontSize: 24,
                                ),
                              ),

                              Text(
                                'on orders over 600 L.E',

                                style:
                                    AppStyles.heading1.copyWith(
                                  color: Colors.white,
                                  height: 1.1,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              const SizedBox(height: 20),

                              GestureDetector(
                                onTap: () {},

                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),

                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    'SHOP NOW',

                                    style:
                                        AppStyles.buttonText.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= CATEGORIES TITLE =================

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          'Explore Categories',
                          style: AppStyles.heading2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ================= CATEGORIES =================

                  SizedBox(
                    height: 88,

                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,

                      padding:
                          const EdgeInsets.symmetric(horizontal: 24),

                      itemCount: categoriesList.length,

                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),

                      itemBuilder: (context, index) {
                        final category =
                            categoriesList[index];

                        return CategoryCard(
                          title: category['title']!,
                          imagePath: category['image']!,

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryProductsScreen(
                                  categoryName:
                                      category['title']!,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= NEW ARRIVALS TITLE =================

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          'New Arrivals',
                          style: AppStyles.heading2,
                        ),

                        Text(
                          'View All',

                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.terracotta,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ================= NEW ARRIVALS PRODUCTS =================

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),

                    child: StreamBuilder<List<ProductModel>>(
                      stream:
                          widget._firestoreService.streamProducts(),

                      builder: (context, snapshot) {

                        if (snapshot.hasError) {
                          print(
                            "Firestore Error: ${snapshot.error}",
                          );

                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: AppStyles.bodySmall,
                            ),
                          );
                        }

                        final products =
                            snapshot.data ?? [];

                    
                        final newArrivals = products
                            .where(
                              (product) =>
                                  product.isNewArrival,
                            )
                            .toList();

                        if (newArrivals.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'No new arrivals available yet.',
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding:
                              const EdgeInsets.only(
                            top: 14,
                            bottom: 24,
                          ),

                          shrinkWrap: true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          itemCount: newArrivals.length,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 270,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),

                          itemBuilder: (context, index) {

                            final product =
                                newArrivals[index];

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
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}