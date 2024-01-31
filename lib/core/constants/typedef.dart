import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// => Either<Failure, T>
/// - [T] Returned when success
/// - [Failure] will be returned when failure
typedef Result<T> = Either<Failure, T>;

/// => Either<Failure, void>
/// - Nothing will returned when success
/// - [Failure] will be returned when failure
typedef ResultVoid = Result<void>;

/// => Future<Either<Failure, T>>
/// - [T] Returned when success
/// - [Failure] will be returned when failure
typedef FResult<T> = Future<Either<Failure, T>>;

/// => Future<Either<Failure, void>>
/// - Nothing will returned when success
/// - [Failure] will be returned when failure
typedef FResultVoid = FResult<void>;
