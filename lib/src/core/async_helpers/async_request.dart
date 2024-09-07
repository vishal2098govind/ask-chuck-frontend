import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class AsyncRequest extends Equatable {
  final String baseUrl;
  final String endpoint;
  final String? contentType;
  final Map<String, dynamic>? headers;
  final List<int>? validStatuses;

  const AsyncRequest({
    this.endpoint = "",
    this.contentType,
    this.headers,
    this.validStatuses,
    String? baseUrl,
  }) : baseUrl = baseUrl ?? "https://ask-chuck-api-rj3nriizfq-uc.a.run.app";

  Future<String> get requestUrl async => "$baseUrl${(await prepareEndpoint())}";

  FutureOr<String> prepareEndpoint() {
    return endpoint;
  }

  FutureOr<Map<String, dynamic>?> prepareRequestBody() {
    return null;
  }

  FutureOr<Map<String, dynamic>?> prepareRequestQueryParams() {
    return null;
  }

  @override
  @mustCallSuper
  List<Object?> get props => [
        baseUrl,
        endpoint,
        contentType,
        headers,
        validStatuses,
      ];
}
