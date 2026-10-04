import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/providers/cart_provider.dart';

class OrderSummaryTile extends StatelessWidget {
  final CartProvider cartProvider;

  const OrderSummaryTile({
    super.key,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconColor: AppColors.terracotta,
          collapsedIconColor: Colors.black,
          title: Text(
            'Order Summary (${cartProvider.cartItems.length} items)',
            style: AppStyles.heading2.copyWith(fontSize: 16, color: AppColors.black),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Items Ordered',
                style: AppStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.terracotta),
              ),
            ),
            const SizedBox(height: 10),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: AppStyles.bodyMedium.copyWith(fontSize: 18, color: AppColors.black),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: AppStyles.bodyMedium.copyWith(fontSize: 14, color: AppColors.black),
                            ),
                            Text(
                              'Size : ${item.selectedSize}\nQuantity : ${item.quantity}\nPrice : LE. ${item.price.toStringAsFixed(2)}',
                              style: AppStyles.bodySmall.copyWith(
                                fontSize: 12,
                                color: const Color.fromARGB(255, 147, 146, 146),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}