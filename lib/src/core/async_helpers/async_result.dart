import 'package:ask_chuck/src/core/async_helpers/fp_app_failure.dart';
import 'package:equatable/equatable.dart';

import 'package:ask_chuck/src/core/async_helpers/async_request.dart';

sealed class AsyncResult<T> {}

class AsyncSuccessResponse<T> extends Equatable implements AsyncResult<T> {
  final T response;
  final AsyncRequest request;

  const AsyncSuccessResponse({required this.response, required this.request});

  @override
  List<Object?> get props => [response, request];
}

class AsyncFailureResponse<T> extends AppFailure
    implements Equatable, AsyncResult<T> {
  final AsyncRequest request;

  AsyncFailureResponse({
    required this.request,
    super.exception,
    String? failureMessage,
    required super.parentFailure,
  }) : super(
          failureMessage: failureMessage ?? parentFailure?.failureMessage,
        );

  @override
  List<Object?> get props => [request];
}

extension AsyncResultX<T> on AsyncResult<T> {
  /// Use it when need not care much about AsyncFailureRespone
  T? get response {
    return switch (this) {
      AsyncSuccessResponse(response: final response) => response,
      _ => null,
    };
  }
}
