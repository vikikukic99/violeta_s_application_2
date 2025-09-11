import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_export.dart';
import '../notifier/activity_selection_notifier.dart';

/// Text field with a single inline **AI Assistant** trigger.
/// When tapped, shows a bottom sheet with suggestions.
/// Tap on a suggestion inserts it directly into the field.
class AIEnhancedTextField extends ConsumerStatefulWidget {
  const AIEnhancedTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.contentPadding,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final EdgeInsets? contentPadding;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  ConsumerState<AIEnhancedTextField> createState() =>
      _AIEnhancedTextFieldState();
}

class _AIEnhancedTextFieldState extends ConsumerState<AIEnhancedTextField> {
  bool _isLoadingSuggestions = false;

  Future<void> _openAISuggestions() async {
    if (_isLoadingSuggestions) return;
    
    setState(() => _isLoadingSuggestions = true);
    
    try {
      final notifier = ref.read(activitySelectionNotifierProvider.notifier);
      final suggestions = await notifier.getAISuggestions();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: appTheme.white_A700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.h)),
        ),
        builder: (_) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.h,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: appTheme.blue_gray_100,
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: appTheme.green_500),
                      SizedBox(width: 8.h),
                      Text(
                        'AI suggestions',
                        style: TextStyleHelper.instance.title16SemiBoldPoppins
                            .copyWith(color: appTheme.blue_gray_900),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (suggestions.isEmpty) 
                    Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Text(
                        'No suggestions available right now. Try again or write your own description.',
                        style: TextStyleHelper.instance.body14RegularInter
                            .copyWith(color: appTheme.gray_600),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...suggestions.map((s) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: InkWell(
                          onTap: () {
                            // Insert into field
                            widget.controller.text = s;
                            widget.controller.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: widget.controller.text.length),
                            );
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(10.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.h),
                            decoration: BoxDecoration(
                              color: appTheme.gray_50,
                              border: Border.all(color: appTheme.blue_gray_100),
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                            child: Text(
                              s,
                              style: TextStyleHelper.instance.body14RegularInter
                                  .copyWith(color: appTheme.blue_gray_800),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Show error to user if something goes wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to fetch AI suggestions. Try again later.'),
            backgroundColor: appTheme.colorFFEF44,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingSuggestions = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: appTheme.blue_gray_100),
      borderRadius: BorderRadius.circular(12.h),
    );

    return TextFormField(
      controller: widget.controller,
      maxLines: 4,
      minLines: 3,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: TextStyleHelper.instance.body14RegularInter
          .copyWith(color: appTheme.blue_gray_900),
      decoration: InputDecoration(
        hintText: widget.hintText ?? '',
        hintStyle: TextStyleHelper.instance.body14RegularInter
            .copyWith(color: appTheme.blue_gray_300),
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
        filled: true,
        fillColor: appTheme.white_A700,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: appTheme.colorFFEF44),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: appTheme.colorFFEF44),
        ),
        // Only ONE AI entry point: a small icon button inside the field.
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 8.h),
          child: IconButton(
            tooltip: 'AI Assistant',
            onPressed: _isLoadingSuggestions ? null : _openAISuggestions,
            icon: _isLoadingSuggestions 
                ? SizedBox(
                    width: 16.h,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appTheme.green_500,
                    ),
                  )
                : Icon(
                    Icons.auto_awesome,
                    color: appTheme.green_500,
                  ),
          ),
        ),
      ),
    );
  }
}
