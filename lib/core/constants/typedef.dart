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

typedef Resp = Either<ErrorResponse, SuccessResponse>;
typedef RespData<T> = Either<ErrorResponse, DataResponse<T>>;

/// => Future<Either<ErrorResponse, SuccessResponse>>
/// - Returns:
///   + [ErrorResponse] will be returned when failure
///   + [SuccessResponse] will be returned when success
///
/// - Notes: [FRespData] when response contains data
typedef FResp = Future<Resp>;

/// [T] is data type in 'data' property
typedef FRespData<T> = Future<RespData<T>>;
