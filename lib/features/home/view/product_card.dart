import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    
    final defaultSize = product.sizes.isNotEmpty
        ? product.sizes.first
        : const ProductSizeOption(sizeLabel: 'FULL SIZE', price: 0.0);

    return Container(
      width: 190,
      height: 204,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFCCCCCC),
          width: 1,
        ),
      
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  width: 180,
                  height: 180,
                  color: const Color(0xFFF9F9F9),
                  child: Image.network(
                    product.images.isNotEmpty ? product.images.first : '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.name} - ${defaultSize.sizeLabel}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.bodySmall.copyWith(
                          height: 1.1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'L.E. ${defaultSize.price.toStringAsFixed(2)}',
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            
                            ),
                          ),
                        InkWell(
                                    onTap: () {
                              
                                      Provider.of<CartProvider>(context, listen: false)
                                          .addToCartFromHome(product);

                                  
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                    
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle_outline_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${product.name} added to cart!',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: AppColors.black.withOpacity(0.9),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(9),
                                          ),
                                          duration: const Duration(seconds: 2),
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
                                ),
                                  )
                                                          ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

            Positioned(
              top: 12,  
              left: -2,  
              child: Image.asset(
                'assets/images/arrowSamples.png',
                height: 33,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: const BoxDecoration(
                      color: AppColors.terracotta,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}