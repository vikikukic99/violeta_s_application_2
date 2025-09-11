// lib/presentation/activity_selection_screen/widgets/ai_enhanced_text_field.dart
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:convert';
import '../../../core/app_export.dart'; // appTheme + TextStyleHelper

/// Text field with an "AI Assistant" button.
/// When the button is tapped, a bottom-sheet pops up with suggestions.
/// Tapping a suggestion inserts it into the field automatically.
class AIEnhancedTextField extends StatefulWidget {
  const AIEnhancedTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.contentPadding,
    this.onChanged,
    this.validator,
    this.suggestions,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final EdgeInsets? contentPadding;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final List<String>? suggestions;

  @override
  State<AIEnhancedTextField> createState() => _AIEnhancedTextFieldState();
}

class _AIEnhancedTextFieldState extends State<AIEnhancedTextField> {
  List<String> _suggestions = [];
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _suggestions = widget.suggestions ??
        const [
          "I love exploring new walking routes and discovering hidden gems in the city.",
          "Looking for motivated fitness companions who enjoy morning walks and healthy conversations.",
          "Passionate about wellness and building meaningful connections through shared activities.",
          "Training for my fitness goals and would love accountability buddies for regular activities.",
        ];
  }

  Future<void> _fetchAISuggestions() async {
    setState(() {
      _isLoadingSuggestions = true;
    });

    try {
      // Get context from parent (if available)
      final requestData = {
        'activities': [],
        'location': '',
        'preferredTime': '',
      };

      final response = await html.HttpRequest.request(
        '/api/generate-suggestions',
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json',
        },
        sendData: jsonEncode(requestData),
        withCredentials: true,
      );

      if (response.status == 200) {
        final data = jsonDecode(response.responseText ?? '{}');
        if (data['suggestions'] != null && data['suggestions'] is List) {
          setState(() {
            _suggestions = List<String>.from(data['suggestions']);
            _isLoadingSuggestions = false;
          });
        } else {
          setState(() {
            _isLoadingSuggestions = false;
          });
        }
      } else {
        setState(() {
          _isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      print('Error fetching AI suggestions: $e');
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  void _applySuggestion(String text) {
    widget.controller.text = text;
    widget.controller.selection =
        TextSelection.fromPosition(TextPosition(offset: text.length));
    widget.onChanged?.call(text);
    Navigator.of(context).maybePop(); // close the sheet if open
    setState(() {}); // optional visual refresh
  }

  Future<void> _openAISuggestionsSheet() async {
    // Fetch fresh suggestions when opening the sheet
    await _fetchAISuggestions();
    
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      backgroundColor: appTheme.white_A700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.h)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grab handle
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
                        size: 18.h, color: appTheme.green_600),
                    SizedBox(width: 8.h),
                    Text(
                      'AI Suggestions',
                      style: TextStyleHelper.instance.title16SemiBoldPoppins
                          .copyWith(color: appTheme.blue_gray_900),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Loading or suggestions list
                _isLoadingSuggestions
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.h),
                          child: CircularProgressIndicator(
                            color: appTheme.green_500,
                          ),
                        ),
                      )
                    : Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final s = _suggestions[index];
                      return _SuggestionTile(
                        text: s,
                        onTap: () => _applySuggestion(s),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The main input
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          maxLines: 5,
          minLines: 3,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Type here…',
            hintStyle: TextStyleHelper.instance.body14RegularInter
                .copyWith(color: appTheme.blue_gray_300),
            filled: true,
            fillColor: appTheme.white_A700,
            contentPadding: widget.contentPadding ?? EdgeInsets.all(16.h),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.blue_gray_100),
              borderRadius: BorderRadius.circular(12.h),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.green_500, width: 1.5),
              borderRadius: BorderRadius.circular(12.h),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.deep_orange_A700),
              borderRadius: BorderRadius.circular(12.h),
            ),
          ),
          style: TextStyleHelper.instance.body14RegularInter
              .copyWith(color: appTheme.blue_gray_800, height: 1.4),
        ),
        SizedBox(height: 10.h),

        // AI Assistant pill (opens the sheet)
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.h),
            onTap: _openAISuggestionsSheet,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
              decoration: BoxDecoration(
                color: appTheme.green_50,
                borderRadius: BorderRadius.circular(10.h),
                border: Border.all(color: appTheme.green_100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome,
                      size: 16.h, color: appTheme.green_600),
                  SizedBox(width: 6.h),
                  Text(
                    'AI Assistant',
                    style: TextStyleHelper.instance.body12MediumPoppins
                        .copyWith(color: appTheme.green_600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.h),
      onTap: onTap,
      child: Container
      (
        width: double.infinity,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: appTheme.green_50,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: appTheme.green_100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.bolt_rounded, size: 18.h, color: appTheme.green_600),
            SizedBox(width: 8.h),
            Expanded(
              child: Text(
                text,
                style: TextStyleHelper.instance.body12RegularInter
                    .copyWith(color: appTheme.blue_gray_800, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
