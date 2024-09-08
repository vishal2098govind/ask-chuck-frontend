import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/core/async_helpers/fp_app_failure.dart';
import 'package:ask_chuck/src/core/interceptors.dart';
import 'package:ask_chuck/src/features/chat/models/converse_api/request.dart';
import 'package:ask_chuck/src/features/chat/models/converse_api/response.dart';

class ChatRepository {
  final Dio _dio;

  ChatRepository() : _dio = Dio()..interceptors.add(const DioInterceptor());

  Future<AsyncResult<ConverseResponse>> converse(
    ConverseRequest request,
  ) async {
    try {
      final endpoint = await request.requestUrl;
      final prepareRequestQueryParams =
          await request.prepareRequestQueryParams();

      final result = await _dio.get(
        endpoint,
        queryParameters: prepareRequestQueryParams,
      );

      return AsyncSuccessResponse(
        response: ConverseResponse.fromMap(result.data),
        request: request,
      );
    } catch (e) {
      debugPrint("failed to converse: $e");

      return AsyncFailureResponse(
        request: request,
        parentFailure: const AppFailure(
          failureMessage: "Something went wrong",
        ),
      );
    }
  }
}
