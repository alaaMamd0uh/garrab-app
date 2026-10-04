import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/core/widgets/custom_button.dart';
import 'package:garrib_app/data/models/product_model.dart';
import 'package:garrib_app/providers/cart_provider.dart';
import 'package:garrib_app/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  int selectedSizeIndex = 0;
  int quantity = 1;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSize = widget.product.sizes.isNotEmpty
        ? widget.product.sizes[selectedSizeIndex]
        : null;

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.product);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    'Details',
                    style: AppStyles.heading2.copyWith(fontSize: 22),
                  ),
                  
                  _buildCircleButton(
                    icon: isFav ? Icons.favorite : Icons.favorite_border,
                    iconColor: isFav ? AppColors.black : AppColors.black,
                    iconSize: 23,
                    onTap: () {
                      final favProvider = Provider.of<FavoritesProvider>(context, listen: false);
                      final wasFav = favProvider.isFavorite(widget.product);

                      favProvider.toggleFavorite(widget.product);

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                !wasFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  !wasFav
                                      ? '${widget.product.name} added to favorites!'
                                      : '${widget.product.name} removed from favorites!',
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
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 33),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 380,
                        width: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.product.images.isEmpty
                                ? 1
                                : widget.product.images.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final imageUrl = widget.product.images.isNotEmpty
                                  ? widget.product.images[index]
                                  : '';
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    color: const Color(0xFFF9F9F9),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 19),

                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.product.images.isEmpty
                            ? 1
                            : widget.product.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? AppColors.black
                                : const Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 27),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: AppStyles.heading1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'L.E. ${currentSize != null ? currentSize.price.toStringAsFixed(2) : (widget.product.sizes.isNotEmpty ? widget.product.sizes.first.price.toStringAsFixed(2) : '0.00')}',
                          style: AppStyles.heading2,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Text('Size Pill', style: AppStyles.bodyMedium),
                    const SizedBox(height: 12),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(widget.product.sizes.length, (index) {
                          final sizeItem = widget.product.sizes[index];
                          final isSelected = selectedSizeIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSizeIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warmcream,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.terracotta
                                      : Colors.transparent,
                                  width: 2.1,
                                ),
                              ),
                              child: Text(
                                sizeItem.sizeLabel,
                                style: AppStyles.bodySmall.copyWith(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Text('Quantity', style: AppStyles.bodyMedium),
                        const SizedBox(width: 20),
                        _buildCounterButton(
                          icon: Icons.remove,
                          isIncrement: false,
                          onTap: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '$quantity',
                            style: AppStyles.heading2.copyWith(fontSize: 16),
                          ),
                        ),
                        _buildCounterButton(
                          icon: Icons.add,
                          isIncrement: true,
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Text('Product Details', style: AppStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: AppStyles.bodySmall.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF888888),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),


Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.softgrey, 
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
    
      Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.terracotta.withOpacity(0.15),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.terracotta,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flat Shipping Rate: L.E. 50',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Estimated Delivery: Oct 15 – Oct 20',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1, color: Color.fromARGB(255, 229, 230, 232)),
      ),

    
      Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.terracotta.withOpacity(0.15),
            child: const Icon(
              Icons.autorenew_rounded,
              color: AppColors.terracotta,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Complimentary 14 Day Returns',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Prepaid return shipping label included in every box.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomButton(
                text: 'ADD TO YOUR CART',
                svgPath: 'assets/icons/c.svg',
                width: double.infinity,
                onPressed: () {
                  final selectedSizeItem = widget.product.sizes.isNotEmpty
                      ? widget.product.sizes[selectedSizeIndex]
                      : null;

                  final String sizeLabel = selectedSizeItem?.sizeLabel ?? '';
                  final double price = selectedSizeItem?.price ?? 0.0;

                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    product: widget.product,
                    selectedSize: sizeLabel,
                    price: price,
                    quantity: quantity,
                  );

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.product.name} added to cart!'),
                      backgroundColor: AppColors.black.withOpacity(0.9),
                      behavior: SnackBarBehavior.floating,
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    Color iconColor = AppColors.black,
    double iconSize = 20,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required bool isIncrement,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 24,
        decoration: BoxDecoration(
          color: isIncrement ? AppColors.terracotta : AppColors.warmcream,
          border: isIncrement
              ? null
              : Border.all(
                  color: AppColors.terracotta,
                  width: .5,
                ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isIncrement ? Colors.white : AppColors.black,
        ),
      ),
    );
  }
}