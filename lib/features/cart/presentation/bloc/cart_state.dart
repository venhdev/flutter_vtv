part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState({
    this.message,
  });

  final String? message;

  @override
  List<Object?> get props => [message];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final CartResp cart;

  const CartLoaded(
    this.cart, {
    super.message,
  });

  @override
  List<Object?> get props => [cart, message];
}

final class CartError extends CartState {
  const CartError({
    required super.message,
  });

  @override
  List<Object?> get props => [message];
}

final class CartSuccess extends CartState {
  const CartSuccess({
    required super.message,
  });

  @override
  List<Object?> get props => [message];
}
