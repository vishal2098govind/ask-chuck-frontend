import 'package:ask_chuck/src/core/async_helpers/async_result.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/close_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/close_session_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/create_new_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/create_new_session_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/get_active_sesions_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/get_active_sesions_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/send_task_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/send_task_api/response.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/start_session_api/request.dart';
import 'package:ask_chuck/src/features/interactive_avatar/models/start_session_api/response.dart';

abstract class HeygenRepo {
  Future<AsyncResult<CreateNewSessionResponse>> createNewSession(
    CreateNewSessionRequest request,
  );

  Future<AsyncResult<SendTaskResponse>> sendTask(
    SendTaskRequest request,
  );

  Future<AsyncResult<StartSessionResponse>> startSession(
    StartSessionRequest request,
  );

  Future<AsyncResult<CloseSessionResponse>> closeSession(
    CloseSessionRequest request,
  );

  Future<AsyncResult<GetActiveSessionsResponse>> getActiveSessions(
    GetActiveSessionsRequest request,
  );
}
