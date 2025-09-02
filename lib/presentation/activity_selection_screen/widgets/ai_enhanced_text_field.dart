import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../services/openai_client.dart';
import '../../../services/openai_service.dart';

class AIEnhancedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;

  const AIEnhancedTextField({
    Key? key,
    required this.controller,
    this.hintText = 'Tell us about yourself...',
    this.onChanged,
    this.validator,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<AIEnhancedTextField> createState() => _AIEnhancedTextFieldState();
}

class _AIEnhancedTextFieldState extends State<AIEnhancedTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isAILoading = false;
  bool _showSuggestions = false;
  List<String> _suggestions = [];
  OpenAIClient? _openAIClient;

  @override
  void initState() {
    super.initState();
    _initializeAI();
    _focusNode.addListener(_onFocusChange);
  }

  void _initializeAI() {
    try {
      final service = OpenAIService();
      _openAIClient = OpenAIClient(service.dio);
    } catch (e) {
      // AI features will be disabled if API key not available
      _openAIClient = null;
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _openAIClient != null) {
      _generateSuggestions();
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  Future<void> _generateSuggestions() async {
    if (_openAIClient == null) return;

    setState(() {
      _isAILoading = true;
    });

    try {
      final suggestions = await _openAIClient!.generateSuggestions(
        userInput: widget.controller.text,
        context:
            'User is describing themselves for finding walking and fitness buddies',
        maxSuggestions: 3,
      );

      setState(() {
        _suggestions = suggestions;
        _showSuggestions = suggestions.isNotEmpty;
        _isAILoading = false;
      });
    } catch (e) {
      setState(() {
        _isAILoading = false;
        _showSuggestions = false;
      });
    }
  }

  Future<void> _enhanceText() async {
    if (_openAIClient == null || widget.controller.text.trim().isEmpty) return;

    setState(() {
      _isAILoading = true;
    });

    try {
      final enhancedText = await _openAIClient!.enhanceText(
        originalText: widget.controller.text,
        style: 'friendly',
      );

      widget.controller.text = enhancedText;
      if (widget.onChanged != null) {
        widget.onChanged!(enhancedText);
      }

      setState(() {
        _isAILoading = false;
        _showSuggestions = false;
      });
    } catch (e) {
      setState(() {
        _isAILoading = false;
      });
    }
  }

  void _applySuggestion(String suggestion) {
    widget.controller.text = suggestion;
    if (widget.onChanged != null) {
      widget.onChanged!(suggestion);
    }
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            borderRadius: BorderRadius.circular(12.h),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? appTheme.green_500
                  : appTheme.blue_gray_100,
              width: 1.5.h,
            ),
            boxShadow: [
              BoxShadow(
                color: appTheme.black_900.withAlpha(13),
                blurRadius: 8.h,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                validator: widget.validator,
                maxLines: 4,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyleHelper.instance.body14RegularInter
                      .copyWith(color: appTheme.gray_600),
                  border: InputBorder.none,
                  contentPadding: widget.contentPadding ??
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
                ),
                style: TextStyleHelper.instance.body14RegularInter,
              ),
              if (_openAIClient != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray_50,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.h),
                      bottomRight: Radius.circular(12.h),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 16.h,
                        color: appTheme.green_500,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Text(
                          'AI Assistant',
                          style: TextStyleHelper.instance.body12RegularInter
                              .copyWith(color: appTheme.gray_600),
                        ),
                      ),
                      if (_isAILoading)
                        SizedBox(
                          height: 16.h,
                          width: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: appTheme.green_500,
                          ),
                        ),
                      if (!_isAILoading &&
                          widget.controller.text.trim().isNotEmpty)
                        GestureDetector(
                          onTap: _enhanceText,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.h, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: appTheme.green_500,
                              borderRadius: BorderRadius.circular(4.h),
                            ),
                            child: Text(
                              'Enhance',
                              style: TextStyleHelper.instance.body12RegularInter
                                  .copyWith(color: appTheme.white_A700),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_showSuggestions && _suggestions.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(12.h),
              border: Border.all(color: appTheme.green_100),
              boxShadow: [
                BoxShadow(
                  color: appTheme.green_500.withAlpha(26),
                  blurRadius: 8.h,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16.h,
                      color: appTheme.green_500,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      'AI Suggestions',
                      style: TextStyleHelper.instance.body12MediumInter
                          .copyWith(color: appTheme.green_600),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ...List.generate(
                  _suggestions.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: GestureDetector(
                      onTap: () => _applySuggestion(_suggestions[index]),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                          color: appTheme.green_50,
                          borderRadius: BorderRadius.circular(8.h),
                          border: Border.all(
                            color: appTheme.green_100,
                            width: 1.h,
                          ),
                        ),
                        child: Text(
                          _suggestions[index],
                          style: TextStyleHelper.instance.body12RegularInter
                              .copyWith(color: appTheme.blue_gray_800),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}