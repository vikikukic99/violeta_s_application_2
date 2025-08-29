import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/payment_methods_notifier.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  PaymentMethodsScreenState createState() => PaymentMethodsScreenState();
}

class PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_100,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                SizedBox(height: 24.h),
                _buildPaymentContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        boxShadow: [
          BoxShadow(
            color: appTheme.color0C0000,
            spreadRadius: 0,
            blurRadius: 2.h,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgButtonBlueGray80028x16,
            height: 28.h,
            width: 16.h,
          ),
          SizedBox(width: 12.h),
          Text(
            'Payment Methods',
            style: TextStyleHelper.instance.title20SemiBoldInter
                .copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPaymentContent(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(paymentMethodsNotifier);

        ref.listen<PaymentMethodsState>(
          paymentMethodsNotifier,
          (previous, current) {
            if (current.isFormSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment method saved successfully')),
              );
            }
          },
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentMethod(context),
              SizedBox(height: 26.h),
              _buildAddNewPaymentSection(context, state),
              SizedBox(height: 22.h),
              _buildQuickPaymentOptions(context),
              SizedBox(height: 22.h),
              _buildTermsText(context),
              SizedBox(height: 22.h),
              _buildSaveButton(context),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildCurrentMethod(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Method',
          style: TextStyleHelper.instance.title16MediumInter
              .copyWith(color: appTheme.blue_gray_800, height: 1.25),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(26.h),
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            borderRadius: BorderRadius.circular(12.h),
            boxShadow: [
              BoxShadow(
                color: appTheme.color0C0000,
                spreadRadius: 0,
                blurRadius: 2.h,
                offset: Offset(0, 1.h),
              ),
            ],
          ),
          child: Row(
            children: [
              CustomIconButton(
                iconPath: ImageConstant.imgSearch,
                backgroundColor: appTheme.blue_50_01,
                size: 40.h,
                borderRadius: 8.h,
                padding: EdgeInsets.all(6.h),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visa ending in 4567',
                      style: TextStyleHelper.instance.title16RegularInter
                          .copyWith(
                              color: appTheme.blue_gray_900, height: 1.25),
                    ),
                    Text(
                      'Expires 05/25',
                      style: TextStyleHelper.instance.body12RegularInter
                          .copyWith(height: 1.25),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
                decoration: BoxDecoration(
                  color: appTheme.green_50,
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: Text(
                  'Default',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.green_700, height: 1.25),
                ),
              ),
              SizedBox(width: 8.h),
              CustomImageView(
                imagePath: ImageConstant.imgButtonBlueGray300,
                height: 24.h,
                width: 4.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildAddNewPaymentSection(
      BuildContext context, PaymentMethodsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add New Payment Method',
          style: TextStyleHelper.instance.title16MediumInter
              .copyWith(color: appTheme.blue_gray_800, height: 1.25),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            borderRadius: BorderRadius.circular(12.h),
            boxShadow: [
              BoxShadow(
                color: appTheme.color0C0000,
                spreadRadius: 0,
                blurRadius: 2.h,
                offset: Offset(0, 1.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Number',
                style: TextStyleHelper.instance.body14MediumInter
                    .copyWith(color: appTheme.blue_gray_800, height: 1.21),
              ),
              SizedBox(height: 4.h),
              CustomEditText(
                controller: state.cardNumberController,
                hintText: '1234 5678 9012 3456',
                rightIcon: ImageConstant.imgDivBlueGray30022x18,
                inputType: TextInputType.number,
                validator: (value) {
                  return ref
                      .read(paymentMethodsNotifier.notifier)
                      .validateCardNumber(value);
                },
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expiry Date',
                          style: TextStyleHelper.instance.body14MediumInter
                              .copyWith(
                                  color: appTheme.blue_gray_800, height: 1.21),
                        ),
                        SizedBox(height: 4.h),
                        CustomEditText(
                          controller: state.expiryDateController,
                          hintText: 'MM/YY',
                          inputType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () => _showDatePicker(context),
                          validator: (value) {
                            return ref
                                .read(paymentMethodsNotifier.notifier)
                                .validateExpiryDate(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CVV',
                          style: TextStyleHelper.instance.body14MediumInter
                              .copyWith(
                                  color: appTheme.blue_gray_800, height: 1.21),
                        ),
                        SizedBox(height: 4.h),
                        CustomEditText(
                          controller: state.cvvController,
                          hintText: '123',
                          rightIcon: ImageConstant.imgDivBlueGray30022x16,
                          inputType: TextInputType.number,
                          validator: (value) {
                            return ref
                                .read(paymentMethodsNotifier.notifier)
                                .validateCVV(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                'Cardholder Name',
                style: TextStyleHelper.instance.body14MediumInter
                    .copyWith(color: appTheme.blue_gray_800, height: 1.21),
              ),
              SizedBox(height: 4.h),
              CustomEditText(
                controller: state.cardholderNameController,
                hintText: 'John Doe',
                validator: (value) {
                  return ref
                      .read(paymentMethodsNotifier.notifier)
                      .validateCardholderName(value);
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(paymentMethodsNotifier.notifier)
                          .toggleSaveCard();
                    },
                    child: Container(
                      width: 16.h,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: appTheme.white_A700,
                        border:
                            Border.all(color: appTheme.black_900, width: 1.h),
                        borderRadius: BorderRadius.circular(1.h),
                      ),
                      child: (state.saveCardForFuture ?? false)
                          ? Icon(
                              Icons.check,
                              size: 12.h,
                              color: appTheme.indigo_A400,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Text(
                    'Save card for future payments',
                    style: TextStyleHelper.instance.body14RegularInter
                        .copyWith(height: 1.21),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(paymentMethodsNotifier.notifier)
                          .toggleSetAsDefault();
                    },
                    child: Container(
                      width: 16.h,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: appTheme.white_A700,
                        border:
                            Border.all(color: appTheme.black_900, width: 1.h),
                        borderRadius: BorderRadius.circular(1.h),
                      ),
                      child: (state.setAsDefault ?? false)
                          ? Icon(
                              Icons.check,
                              size: 12.h,
                              color: appTheme.indigo_A400,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Text(
                    'Set as default payment method',
                    style: TextStyleHelper.instance.body14RegularInter
                        .copyWith(height: 1.21),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildQuickPaymentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Payment Options',
          style: TextStyleHelper.instance.title16MediumInter
              .copyWith(color: appTheme.blue_gray_800, height: 1.25),
        ),
        SizedBox(height: 10.h),
        CustomButton(
          text: 'Pay with Apple Pay',
          leftIcon: ImageConstant.imgIWhiteA70028x14,
          backgroundColor: appTheme.black_900,
          textColor: appTheme.white_A700,
          onPressed: () => _onTapApplePay(context),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Pay with PayPal',
          leftIcon: ImageConstant.imgI28x14,
          backgroundColor: appTheme.light_blue_800,
          textColor: appTheme.white_A700,
          onPressed: () => _onTapPayPal(context),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'Pay with Google Pay',
          leftIcon: ImageConstant.imgIBlueA20001,
          backgroundColor: appTheme.white_A700,
          textColor: appTheme.black_900,
          borderColor: appTheme.blue_gray_100,
          onPressed: () => _onTapGooglePay(context),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildTermsText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By adding a payment method, you agree to our',
            style: TextStyleHelper.instance.body12RegularInter
                .copyWith(height: 1.33),
          ),
          TextSpan(
            text: ' Terms of Service',
            style: TextStyleHelper.instance.body12RegularInter
                .copyWith(color: appTheme.indigo_A400, height: 1.33),
          ),
          TextSpan(
            text: ' and',
            style: TextStyleHelper.instance.body12RegularInter
                .copyWith(height: 1.33),
          ),
          TextSpan(
            text: ' Privacy Policy',
            style: TextStyleHelper.instance.body12RegularInter
                .copyWith(color: appTheme.indigo_A400, height: 1.33),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Section Widget
  Widget _buildSaveButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(paymentMethodsNotifier);

        return CustomButton(
          text: 'Save Payment Method',
          backgroundColor: appTheme.indigo_A400,
          textColor: appTheme.white_A700,
          isEnabled: !state.isLoading,
          onPressed: () => _onTapSavePaymentMethod(context),
        );
      },
    );
  }

  /// Shows date picker for expiry date
  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3650)),
    );
    if (picked != null) {
      String formattedDate =
          '${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}';
      ref.read(paymentMethodsNotifier.notifier).updateExpiryDate(formattedDate);
    }
  }

  /// Handles Apple Pay button tap
  void _onTapApplePay(BuildContext context) {
    // Handle Apple Pay
  }

  /// Handles PayPal button tap
  void _onTapPayPal(BuildContext context) {
    // Handle PayPal
  }

  /// Handles Google Pay button tap
  void _onTapGooglePay(BuildContext context) {
    // Handle Google Pay
  }

  /// Handles save payment method button tap
  void _onTapSavePaymentMethod(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(paymentMethodsNotifier.notifier).savePaymentMethod();
    }
  }
}
