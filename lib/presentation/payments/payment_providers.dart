import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/data/repositories/mock_payment_repository.dart';
import 'package:dropzone_app/domain/entities/payment.dart';
import 'package:dropzone_app/domain/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return MockPaymentRepository();
});

final savedCardsProvider = FutureProvider<List<PaymentMethod>>((ref) async {
  final repo = ref.read(paymentRepositoryProvider);
  return repo.getSavedCards();
});

final payWithCardProvider = FutureProvider.family<PaymentReceipt, double>((ref, amount) async {
  final repo = ref.read(paymentRepositoryProvider);
  return repo.payWithCard(bookingId: 'TEMP', amount: amount, currency: 'AED');
});
