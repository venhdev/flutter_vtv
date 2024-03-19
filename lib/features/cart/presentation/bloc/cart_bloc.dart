import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/cart_repository.dart';
import '../../domain/response/cart_resp.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<InitialCart>(_onInitialCart);
    on<FetchCart>(_onFetchCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCart>(_onUpdateCart);
    on<DeleteCart>(_onRemoveCart);
    on<DeleteCartByShopId>(_onDeleteCartByShopId);
  }

  final CartRepository _cartRepository;

  void _onInitialCart(InitialCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final resp = await _cartRepository.getCarts();

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) => emit(CartLoaded(ok.data)),
    );
  }

  void _onFetchCart(FetchCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp = await _cartRepository.getCarts();

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) => emit(CartLoaded(ok.data, message: ok.message)),
    );
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());

    final resp =
        await _cartRepository.addToCart(event.productVariantId, event.quantity);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        // emit(CartSuccess(message: ok.message));
        add(FetchCart());
      },
    );
  }

  void _onUpdateCart(UpdateCart event, Emitter<CartState> emit) async {
    // emit(CartLoading());
    log('event ${event.toString()}');

    final prevState = state as CartLoaded;

    final resp = await _cartRepository.updateCart(event.cartId, event.quantity);

    resp.fold(
      (error) => emit(CartError(message: error.message)),
      (ok) {
        // emit(CartSuccess(message: ok.message));
        // add(FetchCart());
        log('prevState.quantity ${prevState.cart.cartByShopDTOs[event.shopIndex].carts[event.cartIndex].quantity}');
        log('event.quantity ${event.quantity}');
        //? no re-render, so update cart in local state
        // final newCartState = prevState.cart.copyWith(
        //   cartByShopDTOs: prevState.cart.cartByShopDTOs.map(
        //     (cartsByShop) {
        //       if (cartsByShop.shopId == prevState.cart.cartByShopDTOs[event.shopIndex].shopId) {
        //         return cartsByShop.copyWith(
        //           carts: (cartsByShop.carts[event.cartIndex].quantity == 1 && event.quantity == -1)
        //               ? (cartsByShop.carts..removeAt(event.cartIndex))
        //               : cartsByShop.carts.map(
        //                   (c) {
        //                     if (c.cartId == event.cartId) {
        //                       // if (c.quantity == 1 && event.quantity == -1) {
        //                       //   // fetch cart
        //                       //   add(FetchCart());
        //                       // } else {
        //                       // }
        //                       return c.copyWith(quantity: c.quantity + event.quantity);
        //                     }
        //                     return c;
        //                   },
        //                 ).toList(),
        //         );
        //       }
        //       return cartsByShop;
        //     },
        //   ).toList(),
        // );
        final newCartState = prevState.cart.copyWith(
          cartByShopDTOs: prevState.cart.cartByShopDTOs.map(
            (cartsByShop) {
              if (cartsByShop.shopId ==
                  prevState.cart.cartByShopDTOs[event.shopIndex].shopId) {
                return cartsByShop.copyWith(
                  carts: cartsByShop.carts.map(
                    (c) {
                      if (c.cartId == event.cartId) {
                        if (c.quantity == 1 && event.quantity == -1) {
                          // fetch cart
                          add(FetchCart());
                        } else {
                          return c.copyWith(
                              quantity: c.quantity + event.quantity);
                        }
                      }
                      return c;
                    },
                  ).toList(),
                );
              }
              return cartsByShop;
            },
          ).toList(),
        );
        emit(CartLoaded(newCartState));
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

  void _onDeleteCartByShopId(
      DeleteCartByShopId event, Emitter<CartState> emit) async {
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
