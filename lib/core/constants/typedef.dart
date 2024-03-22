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

typedef RespEither = Either<ErrorResponse, SuccessResponse>;
typedef RespData<T> = Either<ErrorResponse, DataResponse<T>>;

/// => Future<Either<ErrorResponse, SuccessResponse>>
/// - Returns:
///   + [ErrorResponse] will be returned when failure
///   + [SuccessResponse] will be returned when success
///
/// - Notes: [FRespData] when response contains data
typedef FRespEither = Future<RespEither>;

/// [T] is data type in 'data' property
///
/// - Returns:
///   + [ErrorResponse] will be returned when failure
///   + [RespData] will be returned when success
///
///
/// - Notes: [FRespEither] when response contains no data
typedef FRespData<T> = Future<RespData<T>>;
