import 'package:equatable/equatable.dart';

part 'success_response.dart';
part 'error_response.dart';

abstract class BaseHttpResponse extends Equatable {
  const BaseHttpResponse({
    this.code,
    this.message,
    this.status,
  });

  final int? code;
  final String? message;
  final String? status;

  @override
  List<Object?> get props => [
        code,
        message,
        status,
      ];

  @override
  bool get stringify => true;
}
