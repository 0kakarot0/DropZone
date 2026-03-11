import 'package:dio/dio.dart';
import 'package:dropzone_app/core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Calls the backend to create a Stripe PaymentIntent for a given booking.
/// Returns the client secret needed to initialise the PaymentSheet.
class PaymentService {
  const PaymentService(this._dio);

  final Dio _dio;

  Future<PaymentIntentResult> createPaymentIntent(int bookingId) async {
    final resp = await _dio.post('/api/bookings/$bookingId/payment-intent');
    final data = resp.data as Map<String, dynamic>;
    return PaymentIntentResult(
      clientSecret: data['clientSecret'] as String,
      paymentIntentId: data['paymentIntentId'] as String,
    );
  }

  /// Call this after Stripe PaymentSheet completes successfully.
  /// Asks the backend to verify the payment with Stripe and mark the booking CONFIRMED.
  Future<void> confirmPayment(int bookingId) async {
    await _dio.post('/api/bookings/$bookingId/confirm-payment');
  }
}

class PaymentIntentResult {
  const PaymentIntentResult({
    required this.clientSecret,
    required this.paymentIntentId,
  });

  final String clientSecret;
  final String paymentIntentId;
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final dio = ref.watch(dioProvider);
  return PaymentService(dio);
});
