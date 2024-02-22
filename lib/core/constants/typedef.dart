import 'package:dartz/dartz.dart';

import '../error/failures.dart';
import '../network/base_response.dart';

/// => Either<Failure, T>
/// - [T] Returned when success
/// - [Failure] will be returned when failure
typedef Result<T> = Either<Failure, T>;

/// => Future<Either<Failure, T>>
/// - [T] Returned when success
/// - [Failure] will be returned when failure
typedef FResult<T> = Future<Result<T>>;

/// => Future<Either<ErrorResponse, SuccessResponse>>
/// - Returns:
///   + [ErrorResponse] will be returned when failure
///   + [SuccessResponse] will be returned when success
///
/// - Notes: [RespDataEither] when response contains data
typedef RespEither = Future<Either<ErrorResponse, SuccessResponse>>;

/// [T] is data type in 'data' property
typedef RespEitherData<T> = Future<Either<ErrorResponse, DataResponse<T>>>;
