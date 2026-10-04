import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/core/widgets/custom_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/images/order_success.png', 
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 36),

            
              Text(
                'Order Confirmed !',
                style: AppStyles.heading1.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 16),

            
              Text(
                'Thank you for your order. We’re preparing your decants with care. A confirmation email with tracking details has been sent to your inbox.',
                textAlign: TextAlign.center,
                style: AppStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9E9E9E),
                  height: 1.5,
                ),
              ),

                const SizedBox(height: 60),


              
              CustomButton(
                text: 'Continue Shopping',
                width: double.infinity,
                onPressed: () {
                  
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/mainlayout',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}