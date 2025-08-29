import 'package:flutter/material.dart';
import '../models/payment_methods_model.dart';
import '../../../core/app_export.dart';

part 'payment_methods_state.dart';

final paymentMethodsNotifier = StateNotifierProvider.autoDispose<
    PaymentMethodsNotifier, PaymentMethodsState>(
  (ref) => PaymentMethodsNotifier(
    PaymentMethodsState(
      paymentMethodsModel: PaymentMethodsModel(),
    ),
  ),
);

class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {
  PaymentMethodsNotifier(PaymentMethodsState state) : super(state) {
    initialize();
  }

  void initialize() {
    state = state.copyWith(
      cardNumberController: TextEditingController(),
      expiryDateController: TextEditingController(),
      cvvController: TextEditingController(),
      cardholderNameController: TextEditingController(),
      isLoading: false,
    );
  }

  String? validateCardNumber(String? value) {
    if (value?.isEmpty == true) {
      return 'Card number is required';
    }
    if (value != null && value.replaceAll(' ', '').length < 16) {
      return 'Invalid card number';
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value?.isEmpty == true) {
      return 'Expiry date is required';
    }
    return null;
  }

  String? validateCVV(String? value) {
    if (value?.isEmpty == true) {
      return 'CVV is required';
    }
    if (value != null && value.length < 3) {
      return 'Invalid CVV';
    }
    return null;
  }

  String? validateCardholderName(String? value) {
    if (value?.isEmpty == true) {
      return 'Cardholder name is required';
    }
    return null;
  }

  void updateExpiryDate(String date) {
    state.expiryDateController?.text = date;
  }

  void toggleSaveCard() {
    state = state.copyWith(
      saveCardForFuture: !(state.saveCardForFuture ?? false),
    );
  }

  void toggleSetAsDefault() {
    state = state.copyWith(
      setAsDefault: !(state.setAsDefault ?? false),
    );
  }

  void savePaymentMethod() {
    state = state.copyWith(isLoading: true);

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        // Clear form
        state.cardNumberController?.clear();
        state.expiryDateController?.clear();
        state.cvvController?.clear();
        state.cardholderNameController?.clear();

        state = state.copyWith(
          isLoading: false,
          isFormSubmitted: true,
          saveCardForFuture: false,
          setAsDefault: false,
        );

        // Reset form submitted flag
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            state = state.copyWith(isFormSubmitted: false);
          }
        });
      }
    });
  }
}
