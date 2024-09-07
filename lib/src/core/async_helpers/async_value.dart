import 'package:ask_chuck/src/core/async_helpers/fp_app_failure.dart';
import 'package:equatable/equatable.dart';

sealed class AsyncValue<T> extends Equatable {
  const AsyncValue();

  @override
  List<Object?> get props => [];
}

final class AsyncData<T> extends AsyncValue<T> {
  final T data;
  final bool? fetching;
  const AsyncData({required this.data, this.fetching});

  @override
  String toString() {
    return "AsyncData(data: $data)";
  }

  @override
  List<Object?> get props => [data, fetching];
}

final class AsyncNull<T> extends AsyncValue<T> {
  const AsyncNull();
}

final class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

final class AsyncError<T> extends AsyncValue<T> {
  final AppFailure appFailure;

  const AsyncError({required this.appFailure});

  @override
  String toString() {
    return "AsyncError(appFailure: $appFailure)";
  }

  @override
  List<Object?> get props => [appFailure];
}

extension AsyncValueX<T> on AsyncValue<T> {
  bool get isLoading => switch (this) {
        AsyncLoading() => true,
        _ => false,
      };
}
