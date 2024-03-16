import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/cart_repository.dart';
import '../../domain/response/cart_resp.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<FetchCart>(_onFetchCart);
    on<AddToCart>(_onAddToCart);
    on<DeleteCart>(_onRemoveCart);
    on<DeleteCartByShopId>(_onDeleteCartByShopId);
  }

  final CartRepository _cartRepository;

  void _onFetchCart(FetchCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.getCarts();

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) => emit(CartLoaded(ok.data, message: ok.message)),
    );
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final resp = await _cartRepository.addToCart(event.productVariantId, event.quantity);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        emit(CartSuccess(message: ok.message));
        add(FetchCart());
      },
    );
  }

  void _onRemoveCart(DeleteCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.deleteCart(event.cartId);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        emit(CartSuccess(message: ok.message));
        add(FetchCart());
      },
    );
  }

  void _onDeleteCartByShopId(DeleteCartByShopId event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.deleteCartByShopId(event.shopId);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        emit(CartSuccess(message: ok.message));
        add(FetchCart());
      },
    );
  }
}
