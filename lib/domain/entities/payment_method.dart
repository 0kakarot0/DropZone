/// Payment method for a booking.
enum PaymentMethod {
  card,
  cash,
}

extension PaymentMethodApi on PaymentMethod {
  String get apiValue {
    switch (this) {
      case PaymentMethod.card:
        return 'CARD';
      case PaymentMethod.cash:
        return 'CASH';
    }
  }

  static PaymentMethod fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'CARD':
      default:
        return PaymentMethod.card;
    }
  }
}
