import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:provider/provider.dart';
import 'package:garrib_app/core/util/colors.dart';

import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/providers/favorites_provider.dart';
import 'package:garrib_app/providers/cart_provider.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback? onGoToStore;

  const FavoritesScreen({super.key, this.onGoToStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.softgrey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favorite',
                    style: AppStyles.heading2.copyWith(fontSize: 22),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Positioned(
                        top: 13,
                        right: 11.5,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.terracotta,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Consumer<FavoritesProvider>(
                builder: (context, favProvider, child) {
                  if (favProvider.favoriteItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              'No favorite products yet',
                                style: AppStyles.bodyMedium.copyWith(fontSize: 28,fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Add products to favorites to see\nthem here',
                              textAlign: TextAlign.center,
                              style:AppStyles.bodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.w300,color: const Color.fromARGB(255, 134, 134, 134)),

                              
                            ),
                            const SizedBox(height: 55),
                            GestureDetector(
                              onTap: onGoToStore,
                              child:  Text(
                                'Go to store',
                              style: AppStyles.bodyMedium.copyWith(fontSize: 16,color: AppColors.terracotta),

                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 20,
                      top: 20,
                      bottom: 90,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 270,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                        ),
                    itemCount: favProvider.favoriteItems.length,
                    itemBuilder: (context, index) {
                      final product = favProvider.favoriteItems[index];
                      return _buildFavoriteCard(context, product, favProvider);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildFavoriteCard(
    BuildContext context,
    ProductModel product,
    FavoritesProvider favProvider,
  ) {
    final String imagePath = product.images.isNotEmpty
        ? product.images.first
        : '';
    final double price = product.sizes.isNotEmpty
        ? product.sizes.first.price
        : 0.0;

    return GestureDetector(
      
      onTap: () {
        Navigator.pushNamed(context, '/ProductDetails', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: imagePath.isNotEmpty
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, color: Colors.grey),
                            )
                          : const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold,fontSize: 14,
                          height: 1.1,),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '- ${product.category}',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 133, 133, 133),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'L.E. ${price.toStringAsFixed(2)}',
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<CartProvider>(
                                context,
                                listen: false,
                              ).addToCart(
                                product: product,
                                selectedSize: product.sizes.isNotEmpty
                                    ? product.sizes.first.sizeLabel
                                    : 'Default',
                                price: price,
                                quantity: 1,
                              );

                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} added to cart!',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(
                                    bottom: 0,
                                    left: 20,
                                    right: 20,
                                  ),
                                ),
                              );
                                    },
                                child: const CircleAvatar(
                                          radius: 14, 
                                          backgroundColor: AppColors.black, 
                                          child: Icon(
                                            Icons.add,
                                            size: 20,
                                            color: AppColors.white,  
                                          ),
                                        ),                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (product.hasSamples)
              Positioned(
                  top: 12,  
              left: -1,  
              child: Image.asset(
                'assets/images/arrowSamples.png',
                height: 33,
                fit: BoxFit.contain,)
              
              ),
/////////////////////////////////////////////
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => favProvider.removeFromFavorites(product),
                child: Icon(Icons.close, size: 20, color: Colors.grey.shade500)
/////////////////////////////////////////////
              ),
            ),
          ],
        ),
      ),
    );
  }
}
