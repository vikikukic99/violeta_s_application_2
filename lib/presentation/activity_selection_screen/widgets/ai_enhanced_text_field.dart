import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

/// A single AI-assist trigger that opens a bottom sheet with suggestions.
/// Picking a suggestion will INSERT it into the provided [controller] and close the sheet.
class AIEnhancedTextField extends StatelessWidget {
  const AIEnhancedTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.contentPadding,
    this.onChanged,
    this.validator,
    this.suggestions,
    this.buttonLabel,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final EdgeInsets? contentPadding;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  /// Optional custom suggestions (falls back to 3 defaults if null/empty)
  final List<String>? suggestions;

  /// Optional custom label for the trigger button (default: “AI Assistant”)
  final String? buttonLabel;

  List<String> _defaultSuggestions() => const [
        "I love exploring new walking routes and discovering hidden gems in the city.",
        "Looking for a relaxed evening walk and friendly conversation.",
        "Training for a 10K—open to a quicker pace and longer distance.",
      ];

  List<String> _effectiveSuggestions() {
    final list = (suggestions == null || suggestions!.isEmpty)
        ? _defaultSuggestions()
        : suggestions!;
    // Deduplicate and keep order
    final seen = <String>{};
    final out = <String>[];
    for (final s in list) {
      if (seen.add(s.trim())) out.add(s.trim());
    }
    return out;
  }

  void _openSuggestions(BuildContext context) {
    final items = _effectiveSuggestions();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appTheme.white_A700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.h,
              right: 16.h,
              top: 12.h,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.h,
            ),
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
                    Icon(Icons.auto_awesome,
                        color: appTheme.green_500, size: 18.h),
                    SizedBox(width: 8.h),
                    Text(
                      'AI suggestions',
                      style: TextStyleHelper.instance.title16SemiBoldPoppins
                          .copyWith(color: appTheme.blue_gray_900),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1.h, color: appTheme.blue_gray_100),
                    itemBuilder: (_, i) {
                      final text = items[i];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.h),
                        title: Text(
                          text,
                          style: TextStyleHelper.instance.body14RegularPoppins
                              .copyWith(
                                  color: appTheme.blue_gray_800, height: 1.4),
                        ),
                        onTap: () {
                          // Replace the field content with the suggestion
                          controller.text = text;
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length),
                          );
                          Navigator.pop(ctx);
                          onChanged?.call(controller.text);
                        },
                        trailing: Icon(Icons.chevron_right,
                            color: appTheme.blue_gray_300),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text field
        TextFormField(
          controller: controller,
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(
            hintText: hintText ?? 'Describe your interests...',
            hintStyle: TextStyleHelper.instance.body14RegularPoppins
                .copyWith(color: appTheme.blue_gray_300),
            filled: true,
            fillColor: appTheme.white_A700,
            contentPadding: pad,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.blue_gray_100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.blue_gray_100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.green_500, width: 1.5),
            ),
          ),
          style: TextStyleHelper.instance.body14RegularPoppins
              .copyWith(color: appTheme.blue_gray_900, height: 1.4),
          validator: validator,
          onChanged: onChanged,
        ),
        SizedBox(height: 10.h),

        // SINGLE AI button (the only trigger)
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: appTheme.green_500,
              side: BorderSide(color: appTheme.green_500),
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.h),
              ),
            ),
            onPressed: () => _openSuggestions(context),
            icon: Icon(Icons.auto_awesome, size: 16.h),
            label: Text(
              buttonLabel ?? 'AI Assistant',
              style: TextStyleHelper.instance.body14MediumPoppins
                  .copyWith(color: appTheme.green_500),
            ),
          ),
        ),
      ],
    );
  }
}
