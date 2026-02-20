enum PaymentStatus { pending, authorized, captured, failed, refunded }

enum PaymentMethodType { card }

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
  });

  final String id;
  final String brand;
  final String last4;
  final String expiry;
}

class PaymentReceipt {
  const PaymentReceipt({
    required this.id,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final String currency;
  final DateTime createdAt;
}
