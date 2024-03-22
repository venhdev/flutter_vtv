part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState({
    this.selectedCartIds = const [],
    this.message,
  });

  final String? message;
  final List<String> selectedCartIds;

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
    super.selectedCartIds,
  });

  @override
  List<Object?> get props => [cart, message, selectedCartIds];

  // copyWith
  CartLoaded copyWith({
    CartResp? cart,
    String? message,
    List<String>? selectedCartIds,
  }) {
    return CartLoaded(
      cart ?? this.cart,
      message: message ?? this.message,
      selectedCartIds: selectedCartIds ?? this.selectedCartIds,
    );
  }
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
