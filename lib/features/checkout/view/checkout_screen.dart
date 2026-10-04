import 'package:flutter/material.dart';
import 'package:garrib_app/core/util/style.dart';
import 'package:garrib_app/features/OrderSuccessScreen/view/order_success_screen.dart';
import 'package:garrib_app/features/checkout/view/custom_input_field.dart';
import 'package:garrib_app/features/checkout/view/custom_order_summery.dart';
import 'package:provider/provider.dart';
import 'package:garrib_app/core/util/colors.dart';
import 'package:garrib_app/core/services/email_service.dart';
import 'package:garrib_app/providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expDateController = TextEditingController();
  final _cvcController = TextEditingController();

  // Selection States
  String? _selectedCountry;
  String? _selectedGovernorate;
  String _paymentMethod = '';
  bool _sameBillingAddress = false;

  bool _countryError = false;
  bool _governorateError = false;

  // True while the confirmation email is being sent
  bool _isSending = false;

  final List<String> _countries = ['Egypt'];
  final List<String> _governorates = [
    'Alexandria',
    'Cairo',
    'Giza',
    'Beni Suef',
    'Sohag',
    'Minya',
    'Sharqia',
    'Asyut',
  ];
  String _buildItemsHtml(CartProvider cart) {
    return cart.cartItems
        .map(
          (i) =>
              '''
<tr>
  <td style="padding:14px 0;border-bottom:1px solid #E6E3DC;font-size:15px;color:#1A1A1A;">
    <b>${i.product.name}</b><br>
    <span style="font-size:12px;color:#6B6B6B;">Size: ${i.selectedSize}</span>
  </td>
  <td align="right" style="padding:14px 0;border-bottom:1px solid #E6E3DC;font-size:14px;color:#1A1A1A;">
    x${i.quantity}
  </td>
</tr>''',
        )
        .join();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expDateController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitOrder() async {
    if (_isSending) return;

    setState(() {
      _countryError = _selectedCountry == null;
      _governorateError = _selectedGovernorate == null;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || _countryError || _governorateError) return;

    if (_paymentMethod.isEmpty) {
      _showMessage('Please choose a payment method');
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final subtotal = cartProvider.subtotal;
    final double discount = subtotal >= 600.0 ? (subtotal * 0.25) : 0.00;
    const delivery = 50.00;
    final totalAmount = subtotal > 0 ? (subtotal - discount + delivery) : 0.00;

    setState(() => _isSending = true);

    // Wait for the result so we know whether the email was really sent.
    // Card details are intentionally NOT sent in the email.
    final ok = await EmailService.sendOrderEmail(
      userEmail: _emailController.text.trim(),
      userName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address:
          '${_addressController.text.trim()}, $_selectedGovernorate, $_selectedCountry',
      paymentMethod: _paymentMethod == 'credit'
          ? 'Credit Card'
          : 'Cash On Delivery',
      itemsSummary: _buildItemsHtml(cartProvider),
      subtotal: 'L.E. ${subtotal.toStringAsFixed(2)}',
      discount: discount > 0 ? '- 25%' : 'L.E. 0.00',
      delivery: 'L.E. ${delivery.toStringAsFixed(2)}',
      totalAmount: 'L.E. ${totalAmount.toStringAsFixed(2)}',
    );

    if (!mounted) return;
    setState(() => _isSending = false);

    if (!ok) {
      _showMessage('Could not send the confirmation email. Please try again.');
      return;
    }

    cartProvider.clearCart();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final subtotal = cartProvider.subtotal;
    final double discount = subtotal >= 600.0 ? (subtotal * 0.25) : 0.00;
    const delivery = 50.00;
    final totalAmount = subtotal > 0 ? (subtotal - discount + delivery) : 0.00;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
              child: Row(
                children: [
                  _buildCircleBackButton(context),
                  Expanded(
                    child: Text(
                      'Checkout',
                      textAlign: TextAlign.center,
                      style: AppStyles.heading2.copyWith(fontSize: 22),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(33),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Personal Information'),
                      const SizedBox(height: 12),
                      CustomInputField(
                        hintText: 'Your Name',
                        controller: _nameController,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Please enter your name'
                            : null,
                      ),
                      CustomInputField(
                        hintText: 'Your Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!v.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      CustomInputField(
                        hintText: '100 000 0000',
                        controller: _phoneController,
                        isPhone: true,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Please enter phone number'
                            : null,
                      ),
                      CustomInputField(
                        hintText: 'Your Detailed Address',
                        controller: _addressController,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Please enter your address'
                            : null,
                      ),
                      _buildDropdownField(
                        hint: 'Your Country',
                        value: _selectedCountry,
                        items: _countries,
                        hasError: _countryError,
                        onChanged: (val) {
                          setState(() {
                            _selectedCountry = val;
                            _countryError = false;
                          });
                        },
                      ),
                      _buildDropdownField(
                        hint: 'Your Governorate',
                        value: _selectedGovernorate,
                        items: _governorates,
                        hasError: _governorateError,
                        onChanged: (val) {
                          setState(() {
                            _selectedGovernorate = val;
                            _governorateError = false;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      _buildSectionTitle('Choose a Payment Method'),
                      const SizedBox(height: 12),

                      _buildPaymentCardOption(
                        type: 'credit',
                        title: 'Credit Card',
                        imageWidget: Image.asset(
                          'assets/images/visa.png',
                          width: 80,
                          height: 33,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(width: 4),
                        ),
                      ),

                      if (_paymentMethod == 'credit')
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomInputField(
                                hintText: 'Name on card',
                                controller: _cardNameController,
                                validator: (v) =>
                                    _paymentMethod == 'credit' &&
                                        (v == null || v.trim().isEmpty)
                                    ? 'Required field'
                                    : null,
                              ),
                              CustomInputField(
                                hintText: 'Card Number',
                                controller: _cardNumberController,
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    _paymentMethod == 'credit' &&
                                        (v == null || v.trim().isEmpty)
                                    ? 'Required field'
                                    : null,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Expiration Date',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        CustomInputField(
                                          hintText: 'MM/YY',
                                          controller: _expDateController,
                                          validator: (v) =>
                                              _paymentMethod == 'credit' &&
                                                  (v == null ||
                                                      v.trim().isEmpty)
                                              ? 'Required'
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Security Code',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        CustomInputField(
                                          hintText: 'CVC',
                                          controller: _cvcController,
                                          keyboardType: TextInputType.number,
                                          validator: (v) =>
                                              _paymentMethod == 'credit' &&
                                                  (v == null ||
                                                      v.trim().isEmpty)
                                              ? 'Required'
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // Cash On Delivery Option Box
                      _buildPaymentCardOption(
                        type: 'cash',
                        title: 'Cash On Delivery',
                      ),

                      const SizedBox(height: 12),

                      // Checkbox Billing address
                      Row(
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Checkbox(
                              value: _sameBillingAddress,
                              activeColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              onChanged: (v) => setState(
                                () => _sameBillingAddress = v ?? true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'My billing address is the same as my shipping address.',
                              style: AppStyles.bodyMedium.copyWith(
                                fontSize: 12,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // --- Order Summary ---
                      OrderSummaryTile(cartProvider: cartProvider),

                      const Divider(height: 24),

                      _buildSummaryRow(
                        'Subtotal :',
                        'L.E. ${subtotal.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Discount :',
                        discount > 0 ? '- 25%' : 'L.E. 0.00',
                        valueColor: discount > 0
                            ? AppColors.terracotta
                            : Colors.black,
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Delivery :',
                        'L.E. ${delivery.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Total Amount :',
                        'L.E. ${totalAmount.toStringAsFixed(2)}',
                        isTotal: true,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
                        style: AppStyles.bodySmall.copyWith(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.white,
                          decorationThickness: .8,
                        ),
                      ),
                      Text(
                        'L.E. ${totalAmount.toStringAsFixed(2)}',
                        style: AppStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    // Disabled while the email is being sent
                    onPressed: _isSending ? null : _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Submit Order',
                            style: AppStyles.heading1.copyWith(
                              fontSize: 15,
                              color: AppColors.black,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppStyles.bodyMedium.copyWith(fontSize: 17));
  }

  Widget _buildCircleBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildPaymentCardOption({
    required String type,
    required String title,
    Widget? imageWidget,
  }) {
    final isSelected = _paymentMethod == type;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 227, 227, 227)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.black : Colors.grey,
              size: 25,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppStyles.bodyMedium.copyWith(fontSize: 14),
              ),
            ),
            if (imageWidget != null) imageWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required bool hasError,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: hasError
                ? Border.all(color: Colors.red, width: 1)
                : Border.all(color: const Color.fromARGB(255, 227, 227, 227)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color.fromARGB(255, 234, 234, 234),
              borderRadius: BorderRadius.circular(12),
              hint: Text(
                hint,
                style: AppStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: AppStyles.bodyMedium.copyWith(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Text(
              'Please select $hint',
              style: AppStyles.bodyMedium.copyWith(
                color: Colors.red,
                fontSize: 11,
              ),
            ),
          )
        else
          const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: AppStyles.bodyMedium.copyWith(
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
