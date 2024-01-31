/// - [T] is the return type of the use case.
/// - [Params] is the parameters that the use case needs to run.
abstract class UseCaseHasParams<T, Params> {
  T call(Params params);
}

/// - [T] is the return type of the use case.
abstract class UseCaseNoParam<T> {
  T call();
}

/// - Future[T] is the return type of the use case.
/// - [Params] is the parameters that the use case needs to run.
abstract class FUseCaseHasParams<T, Params> {
  Future<T> call(Params params);
}

/// - Future[T] is the return type of the use case.
abstract class FUseCaseNoParam<T> {
  Future<T> call();
}

//? Why use extend instead of implements?
// - Must follow the interface of the implemented class
// - Cannot access and extend private properties
