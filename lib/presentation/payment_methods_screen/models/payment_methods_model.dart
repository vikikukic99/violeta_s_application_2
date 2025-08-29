import '../../../core/app_export.dart';

/// This class is used in the [PaymentMethodsScreen] screen.

// ignore_for_file: must_be_immutable
class PaymentMethodsModel extends Equatable {
  PaymentMethodsModel({
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.cardholderName,
    this.saveCardForFuture,
    this.setAsDefault,
  }) {
    cardNumber = cardNumber ?? '';
    expiryDate = expiryDate ?? '';
    cvv = cvv ?? '';
    cardholderName = cardholderName ?? '';
    saveCardForFuture = saveCardForFuture ?? false;
    setAsDefault = setAsDefault ?? false;
  }

  String? cardNumber;
  String? expiryDate;
  String? cvv;
  String? cardholderName;
  bool? saveCardForFuture;
  bool? setAsDefault;

  PaymentMethodsModel copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
    bool? saveCardForFuture,
    bool? setAsDefault,
  }) {
    return PaymentMethodsModel(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardholderName: cardholderName ?? this.cardholderName,
      saveCardForFuture: saveCardForFuture ?? this.saveCardForFuture,
      setAsDefault: setAsDefault ?? this.setAsDefault,
    );
  }

  @override
  List<Object?> get props => [
        cardNumber,
        expiryDate,
        cvv,
        cardholderName,
        saveCardForFuture,
        setAsDefault,
      ];
}
