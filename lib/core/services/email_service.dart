import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EmailService {
  static const _serviceId = 'service_ekh6w6c';
  static const _templateId = 'template_t88p0m6';
  static const _publicKey = 'GphXrwNkjM4Bd06OE';

  static Future<bool> sendOrderEmail({
    required String userEmail,
    required String userName,
    required String phone,
    required String address,
    required String paymentMethod,
    required String itemsSummary,
    required String subtotal,
    required String discount,
    required String delivery,
    required String totalAmount,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'to_email': userEmail,
            'user_name': userName,
            'phone': phone,
            'address': address,
            'payment_method': paymentMethod,
            'order_items': itemsSummary,
            'subtotal': subtotal,
            'discount': discount,
            'delivery': delivery,
            'total': totalAmount,
          },
        }),
      );
      debugPrint('EmailJS: ${res.statusCode} ${res.body}');
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('EmailJS error: $e');
      return false;
    }
  }
}