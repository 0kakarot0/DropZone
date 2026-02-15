import 'package:dropzone_app/domain/entities/payment.dart';
import 'package:dropzone_app/domain/repositories/payment_repository.dart';

class MockPaymentRepository implements PaymentRepository {
  final List<PaymentMethod> _cards = [
    const PaymentMethod(id: 'card_1', brand: 'Visa', last4: '4242', expiry: '12/27'),
    const PaymentMethod(id: 'card_2', brand: 'Mastercard', last4: '8321', expiry: '08/26'),
  ];

  @override
  Future<List<PaymentMethod>> getSavedCards() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _cards;
  }

  @override
  Future<PaymentReceipt> payWithCard({
    required String bookingId,
    required double amount,
    required String currency,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return PaymentReceipt(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: currency,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<PaymentReceipt> refund({required String paymentId}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return PaymentReceipt(
      id: 'refund_${DateTime.now().millisecondsSinceEpoch}',
      amount: 0,
      currency: 'AED',
      createdAt: DateTime.now(),
    );
  }
}
