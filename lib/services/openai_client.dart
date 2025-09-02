import 'package:dio/dio.dart';
import 'dart:convert';

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Standard chat completion for AI suggestions
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-5-mini',
    Map<String, dynamic>? options,
    String? reasoningEffort,
    String? verbosity,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'model': model,
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
      };

      // Handle options based on model type
      if (options != null) {
        final filteredOptions = Map<String, dynamic>.from(options);

        // For GPT-5 models, remove unsupported parameters
        if (model.startsWith('gpt-5') ||
            model.startsWith('o3') ||
            model.startsWith('o4')) {
          filteredOptions.removeWhere((key, value) => [
                'temperature',
                'top_p',
                'presence_penalty',
                'frequency_penalty',
                'logit_bias'
              ].contains(key));

          // Convert max_tokens to max_completion_tokens for GPT-5
          if (filteredOptions.containsKey('max_tokens')) {
            filteredOptions['max_completion_tokens'] =
                filteredOptions.remove('max_tokens');
          }
        }

        requestData.addAll(filteredOptions);
      }

      // Add GPT-5 specific parameters
      if (model.startsWith('gpt-5') ||
          model.startsWith('o3') ||
          model.startsWith('o4')) {
        if (reasoningEffort != null)
          requestData['reasoning_effort'] = reasoningEffort;
        if (verbosity != null) requestData['verbosity'] = verbosity;
      }

      final response = await dio.post('/chat/completions', data: requestData);

      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Stream completion for real-time AI suggestions
  Stream<String> streamContentOnly({
    required List<Message> messages,
    String model = 'gpt-5-mini',
    Map<String, dynamic>? options,
    String? reasoningEffort,
    String? verbosity,
  }) async* {
    try {
      final requestData = <String, dynamic>{
        'model': model,
        'messages': messages
            .map((m) => {
                  'role': m.role,
                  'content': m.content,
                })
            .toList(),
        'stream': true,
      };

      // Add options with filtering
      if (options != null) {
        final filteredOptions = Map<String, dynamic>.from(options);
        if (model.startsWith('gpt-5') ||
            model.startsWith('o3') ||
            model.startsWith('o4')) {
          filteredOptions.removeWhere((key, value) => [
                'temperature',
                'top_p',
                'presence_penalty',
                'frequency_penalty',
                'logit_bias'
              ].contains(key));

          if (filteredOptions.containsKey('max_tokens')) {
            filteredOptions['max_completion_tokens'] =
                filteredOptions.remove('max_tokens');
          }
        }
        requestData.addAll(filteredOptions);
      }

      // Add GPT-5 specific parameters
      if (model.startsWith('gpt-5') ||
          model.startsWith('o3') ||
          model.startsWith('o4')) {
        if (reasoningEffort != null)
          requestData['reasoning_effort'] = reasoningEffort;
        if (verbosity != null) requestData['verbosity'] = verbosity;
      }

      final response = await dio.post(
        '/chat/completions',
        data: requestData,
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] ?? '';

          if (content.isNotEmpty) {
            yield content;
          }

          final finishReason = json['choices'][0]['finish_reason'];
          if (finishReason != null) break;
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Generate AI suggestions based on user input
  Future<List<String>> generateSuggestions({
    required String userInput,
    required String context,
    int maxSuggestions = 3,
  }) async {
    try {
      final messages = [
        Message(role: 'system', content: [
          {
            'type': 'text',
            'text':
                '''You are an AI assistant helping users describe themselves for a social fitness app. 
Generate ${maxSuggestions} diverse, engaging suggestions that help users express their personality, interests, and fitness goals. 
Keep suggestions concise (1-2 sentences each), authentic, and relevant to finding walking/fitness buddies.

Context: $context'''
          }
        ]),
        Message(role: 'user', content: [
          {
            'type': 'text',
            'text':
                'Current input: "$userInput". Generate ${maxSuggestions} suggestions to help me complete my profile description.'
          }
        ]),
      ];

      final response = await createChatCompletion(
        messages: messages,
        model: 'gpt-5-mini',
        reasoningEffort: 'minimal',
        options: {'max_completion_tokens': 200},
      );

      // Parse suggestions from response
      final suggestions = response.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
          .where((suggestion) => suggestion.isNotEmpty)
          .take(maxSuggestions)
          .toList();

      return suggestions;
    } catch (e) {
      return [
        'I love exploring new walking routes and discovering hidden gems in the city.',
        'Looking for motivated fitness companions who enjoy morning walks and healthy conversations.',
        'Passionate about wellness and building meaningful connections through shared activities.'
      ];
    }
  }

  /// Enhance user text with AI improvements
  Future<String> enhanceText({
    required String originalText,
    String style = 'friendly',
  }) async {
    try {
      final messages = [
        Message(role: 'system', content: [
          {
            'type': 'text',
            'text':
                '''You are an AI assistant that helps improve profile descriptions for a fitness social app. 
Enhance the given text to be more engaging, authentic, and appealing while maintaining the user's original intent and personality.
Style: $style. Keep the response concise and natural.'''
          }
        ]),
        Message(role: 'user', content: [
          {'type': 'text', 'text': 'Please enhance this text: "$originalText"'}
        ]),
      ];

      final response = await createChatCompletion(
        messages: messages,
        model: 'gpt-5-mini',
        reasoningEffort: 'minimal',
        options: {'max_completion_tokens': 150},
      );

      return response.text.trim();
    } catch (e) {
      return originalText; // Return original if enhancement fails
    }
  }
}

// Support classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}
