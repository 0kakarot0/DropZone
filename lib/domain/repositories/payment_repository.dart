import 'package:dropzone_app/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<List<PaymentMethod>> getSavedCards();
  Future<PaymentReceipt> payWithCard({
    required String bookingId,
    required double amount,
    required String currency,
  });
  Future<PaymentReceipt> refund({required String paymentId});
}
