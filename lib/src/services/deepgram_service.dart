import 'dart:convert';
import 'dart:typed_data';
import 'package:ask_chuck/src/core/async_helpers/async_request.dart';
import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/core/async_helpers/fp_app_failure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeepgramService {
  final String apiKey;
  final String baseUrl = 'https://api.deepgram.com/v1/listen';

  DeepgramService() : apiKey = dotenv.env['DEEPGRAM_API_KEY'] ?? '';

  Future<AsyncResult<String>> transcribeAudio(Uint8List audioData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Token $apiKey',
          'Content-Type': 'audio/wav',
        },
        body: audioData,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return AsyncSuccessResponse(
          response: jsonResponse['results']['channels'][0]['alternatives'][0]
              ['transcript'],
          request: const AsyncRequest(),
        );
      } else {
        return AsyncFailureResponse(
          request: const AsyncRequest(),
          parentFailure:
              const AppFailure(failureMessage: "failed to transcribe"),
        );
      }
    } catch (e) {
      return AsyncFailureResponse(
        request: const AsyncRequest(),
        parentFailure:
            AppFailure(failureMessage: "failed to transcribe", exception: e),
      );
    }
  }
}
