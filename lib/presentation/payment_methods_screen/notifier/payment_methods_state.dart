part of 'payment_methods_notifier.dart';

class PaymentMethodsState extends Equatable {
  final TextEditingController? cardNumberController;
  final TextEditingController? expiryDateController;
  final TextEditingController? cvvController;
  final TextEditingController? cardholderNameController;
  final bool isLoading;
  final bool isFormSubmitted;
  final bool? saveCardForFuture;
  final bool? setAsDefault;
  final PaymentMethodsModel? paymentMethodsModel;

  const PaymentMethodsState({
    this.cardNumberController,
    this.expiryDateController,
    this.cvvController,
    this.cardholderNameController,
    this.isLoading = false,
    this.isFormSubmitted = false,
    this.saveCardForFuture,
    this.setAsDefault,
    this.paymentMethodsModel,
  });

  @override
  List<Object?> get props => [
        cardNumberController,
        expiryDateController,
        cvvController,
        cardholderNameController,
        isLoading,
        isFormSubmitted,
        saveCardForFuture,
        setAsDefault,
        paymentMethodsModel,
      ];

  PaymentMethodsState copyWith({
    TextEditingController? cardNumberController,
    TextEditingController? expiryDateController,
    TextEditingController? cvvController,
    TextEditingController? cardholderNameController,
    bool? isLoading,
    bool? isFormSubmitted,
    bool? saveCardForFuture,
    bool? setAsDefault,
    PaymentMethodsModel? paymentMethodsModel,
  }) {
    return PaymentMethodsState(
      cardNumberController: cardNumberController ?? this.cardNumberController,
      expiryDateController: expiryDateController ?? this.expiryDateController,
      cvvController: cvvController ?? this.cvvController,
      cardholderNameController:
          cardholderNameController ?? this.cardholderNameController,
      isLoading: isLoading ?? this.isLoading,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      saveCardForFuture: saveCardForFuture ?? this.saveCardForFuture,
      setAsDefault: setAsDefault ?? this.setAsDefault,
      paymentMethodsModel: paymentMethodsModel ?? this.paymentMethodsModel,
    );
  }
}
