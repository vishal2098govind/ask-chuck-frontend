import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppFailure extends Equatable {
  final Object? exception;
  final AppFailure? parentFailure;
  final String? failureMessage;

  const AppFailure({
    this.exception,
    this.parentFailure,
    required this.failureMessage,
  });

  String describeFailure() {
    return failureMessage ?? "Something went wrong";
  }

  @nonVirtual
  void logFailure() {
    parentFailure?.logFailure();
    debugPrint(describeFailure());
  }

  @override
  String toString() {
    return "AppFailure: ${describeFailure()}";
  }

  AppFailure copyWith({
    String? failureMessage,
  }) {
    return AppFailure(
      exception: exception,
      parentFailure: parentFailure,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [exception, parentFailure, failureMessage];
}

extension FPAppFailureX on AppFailure {
  void showToaster(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(describeFailure()),
        backgroundColor: Colors.red.withOpacity(0.7),
      ),
    );
  }
}
