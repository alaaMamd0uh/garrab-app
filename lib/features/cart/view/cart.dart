import 'package:flutter/material.dart';

import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/features/checkout/view/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const CartScreen({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softgrey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,  
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Cart',
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
                            border: Border.all(color: Colors.grey.shade300, width: 0.8),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.notifications_outlined,
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
            ),

            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.cartItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 33.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              'Your cart is empty',
                            style: AppStyles.bodyMedium.copyWith(fontSize: 28,fontWeight: FontWeight.w400),

                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Add items you wish to purchase to the\ncart to show them here and proceed to\ncheckout',
                              textAlign: TextAlign.center,
                              style:AppStyles.bodyMedium.copyWith(fontSize: 16,fontWeight: FontWeight.w300,color: const Color.fromARGB(255, 134, 134, 134)),
                              

                            ),
                            const SizedBox(height: 55),
                            GestureDetector(
                              onTap: onStartShopping,
                              child:  Text(
                                'Start shopping now',
                                  style: AppStyles.bodyMedium.copyWith(fontSize: 16,color: AppColors.terracotta),

                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              
          final subtotal = cartProvider.subtotal;


            final double discount = subtotal >= 600.0 ? (subtotal * 0.25) : 0.00;

              const delivery = 50.00;
              final totalAmount = subtotal > 0 ? (subtotal - discount + delivery) : 0.00;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 22),
                          children: [
                            ...List.generate(cartProvider.cartItems.length, (index) {
                              final item = cartProvider.cartItems[index];
                              final String imagePath = item.product.images.isNotEmpty
                                  ? item.product.images.first
                                  : '';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Container(
                                        width: 100,
                                        height: 120,
                                        color: AppColors.white,
                                        child: imagePath.isNotEmpty
                                            ? Image.network(
                                                imagePath,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    const Icon(Icons.image, color: Colors.grey),
                                              )
                                            : const Icon(Icons.image_not_supported, color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.product.name,
                                              style: AppStyles.bodyMedium.copyWith(fontSize: 14,color: AppColors.black),

                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => cartProvider.removeFromCart(index),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 20,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                      
                                          Text(
                                            item.product.category,
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 13),
                                          Text(
                                            'Size Pill\n${item.selectedSize}',
                                        style: AppStyles.bodySmall.copyWith(fontSize: 11,color: AppColors.black),

                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'L.E. ${item.price.toStringAsFixed(2)}',
                                            style: AppStyles.heading2.copyWith(fontSize: 14,color: AppColors.black),

                                              ),
                                              Row(
                                                children: [
                                                  _buildQtyButton(
                                                    icon: Icons.remove,
                                                    onTap: () {
                                                      if (item.quantity > 1) {
                                                        cartProvider.updateQuantity(
                                                            index, item.quantity - 1);
                                                      } else {
                                                        cartProvider.removeFromCart(index);
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text(
                                                      '${item.quantity}',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  _buildQtyButton(
                                                    icon: Icons.add,
                                                    isAdd: true,
                                                    onTap: () {
                                                      cartProvider.updateQuantity(
                                                          index, item.quantity + 1);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 40),
                            
                                  if (subtotal < 600.0) ...[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.terracotta.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Add  L.E. ${(600.0 - subtotal).toStringAsFixed(2)} more to get 25% OFF!',
                                      textAlign: TextAlign.center,
                                      style: AppStyles.bodySmall.copyWith(
                                        color: AppColors.terracotta,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                            _buildSummaryRow('Subtotal :', 'L.E. ${subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                          _buildSummaryRow(
                              'Discount :', 
                              discount > 0 
                                  ? '- 25%' 
                                  : 'L.E. 0.00',
                                  valueColor: discount > 0 ? AppColors.terracotta : Colors.black,
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow('Delivery :', 'L.E. ${delivery.toStringAsFixed(2)}'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1),
                            ),
                            _buildSummaryRow(
                              'Total Amount :',
                              'L.E. ${totalAmount.toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 16,
                          bottom: 20,
                        ),
                        color: AppColors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'L.E. ${(totalAmount + discount).toStringAsFixed(2)}',
                              style: AppStyles.bodySmall.copyWith(fontSize: 14,color:Colors.grey.shade500,decoration: TextDecoration.lineThrough,decorationColor:AppColors.white,decorationThickness: .8,),

                                  
                                  
                                  
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'L.E. ${totalAmount.toStringAsFixed(2)}',
                               style: AppStyles.bodyMedium.copyWith(fontSize: 18,color: AppColors.white),

                                ),
                              ],
                            ),
                            ElevatedButton(
                            onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CheckoutScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child:  Text(
                                'Checkout',
                              style: AppStyles.heading1.copyWith(fontSize: 15,color: AppColors.black),

                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    
    bool isAdd = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: isAdd ? AppColors.terracotta : AppColors.warmcream,
          border: isAdd
        ? null 
        : Border.all(
            color: AppColors.terracotta,    
            width: .5,                   
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isAdd ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false,Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}