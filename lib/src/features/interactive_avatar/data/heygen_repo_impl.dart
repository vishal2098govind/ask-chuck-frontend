import 'package:ask_chuck/src/features/interactive_avatar/models/get_active_sesions_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/get_active_sesions_api/response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/core/async_helpers/fp_app_failure.dart';
import 'package:ask_chuck/src/core/interceptors.dart';
import 'package:ask_chuck/src/features/interactive_avatar/data/heygen_repo.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/close_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/close_session_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/create_new_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/create_new_session_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/send_task_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/send_task_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/start_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/start_session_api/response.dart';

class HeygenRepoImpl extends HeygenRepo {
  final Dio _dio;

  HeygenRepoImpl()
      : _dio = Dio(
          BaseOptions(
            headers: {
              "x-api-key": dotenv.env["HEY_GEN_API_KEY"],
            },
          ),
        )..interceptors.add(const DioInterceptor());

  @override
  Future<AsyncResult<CloseSessionResponse>> closeSession(
    CloseSessionRequest request,
  ) async {
    try {
      final endpoint = await request.requestUrl;

      final body = await request.prepareRequestBody();

      final result = await _dio.post(endpoint, data: body);

      return AsyncSuccessResponse(
        response: CloseSessionResponse.fromMap(result.data),
        request: request,
      );
    } catch (e) {
      return AsyncFailureResponse(
        request: request,
        parentFailure: AppFailure(failureMessage: "$e"),
      );
    }
  }

  @override
  Future<AsyncResult<CreateNewSessionResponse>> createNewSession(
    CreateNewSessionRequest request,
  ) async {
    try {
      final endpoint = await request.requestUrl;

      final body = await request.prepareRequestBody();

      final result = await _dio.post(endpoint, data: body);

      return AsyncSuccessResponse(
        response: CreateNewSessionResponse.fromMap(result.data),
        request: request,
      );
    } catch (e) {
      return AsyncFailureResponse(
        request: request,
        parentFailure: AppFailure(failureMessage: "$e"),
      );
    }
  }

  @override
  Future<AsyncResult<SendTaskResponse>> sendTask(
    SendTaskRequest request,
  ) async {
    try {
      final endpoint = await request.requestUrl;

      final body = await request.prepareRequestBody();

      final result = await _dio.post(endpoint, data: body);

      return AsyncSuccessResponse(
        response: SendTaskResponse.fromMap(result.data),
        request: request,
      );
    } catch (e) {
      return AsyncFailureResponse(
        request: request,
        parentFailure: AppFailure(failureMessage: "$e"),
      );
    }
  }

  @override
  Future<AsyncResult<StartSessionResponse>> startSession(
    StartSessionRequest request,
  ) async {
    try {
      final endpoint = await request.requestUrl;

      final body = await request.prepareRequestBody();

      final result = await _dio.post(endpoint, data: body);

      return AsyncSuccessResponse(
        response: StartSessionResponse.fromMap(result.data),
        request: request,
      );
    } catch (e) {
      return AsyncFailureResponse(
        request: request,
        parentFailure: AppFailure(failureMessage: "$e"),
      );
    }
  }

  @override
  Future<AsyncResult<GetActiveSessionsResponse>> getActiveSessions(
    GetActiveSessionsRequest request,
  ) async {
    try {
      final endpoint = await request.requestUrl;

      final result = await _dio.get(endpoint);

      return AsyncSuccessResponse(
        response: GetActiveSessionsResponse.fromMap(result.data),
        request: request,
      );
    } catch (e) {
      return AsyncFailureResponse(
        request: request,
        parentFailure: AppFailure(failureMessage: "$e"),
      );
    }
  }
}
