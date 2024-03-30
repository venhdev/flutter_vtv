part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

final class InitialCart extends CartEvent {}

final class EmptyCart extends CartEvent {}

final class FetchCart extends CartEvent {
  final List<String> selectedCartIds;

  const FetchCart({this.selectedCartIds = const []});

  @override
  List<Object> get props => [selectedCartIds];
}

final class AddToCart extends CartEvent {
  final int productVariantId;
  final int quantity;

  const AddToCart(this.productVariantId, this.quantity);

  @override
  List<Object> get props => [productVariantId, quantity];
}

final class UpdateCart extends CartEvent {
  final String cartId;
  final int quantity;
  final int cartIndex;
  final int shopIndex;

  const UpdateCart({
    required this.cartId,
    required this.quantity,
    required this.cartIndex,
    required this.shopIndex,
  });

  @override
  List<Object> get props => [cartId, quantity];
}

final class DeleteCart extends CartEvent {
  final String cartId;

  const DeleteCart(this.cartId);

  @override
  List<Object> get props => [cartId];
}

final class DeleteCartByShopId extends CartEvent {
  final String shopId;

  const DeleteCartByShopId(this.shopId);

  @override
  List<Object> get props => [shopId];
}

final class SelectCart extends CartEvent {
  final String cartId;

  const SelectCart(this.cartId);

  @override
  List<Object> get props => [cartId];
}

final class UnSelectCart extends CartEvent {
  final String cartId;

  const UnSelectCart(this.cartId);

  @override
  List<Object> get props => [cartId];
}
