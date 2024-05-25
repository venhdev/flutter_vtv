import 'dart:convert';

import 'package:vtv_common/auth.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/order.dart';
import 'package:vtv_common/profile.dart';

import '../../features/order/domain/dto/webview_payment_param.dart';

// <https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/extra_codec.dart>

class MyExtraCodec extends Codec<Object?, Object?> {
  /// Create a codec.
  const MyExtraCodec();
  @override
  Converter<Object?, Object?> get decoder => const _MyExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _MyExtraEncoder();
}

class _MyExtraDecoder extends Converter<Object?, Object?> {
  const _MyExtraDecoder();
  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    final List<Object?> inputAsList = input as List<Object?>;
    if (inputAsList[0] == 'String' ||
        inputAsList[0] == 'Uri' ||
        inputAsList[0] == 'DateTime' ||
        inputAsList[0] == 'bool' ||
        inputAsList[0] == 'double' ||
        inputAsList[0] == 'num' ||
        inputAsList[0] == 'int') {
      return inputAsList[1];
    }
    if (inputAsList[0] == 'UserInfoEntity') {
      return UserInfoEntity.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'ProductEntity') {
      return ProductEntity.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'OrderEntity') {
      return OrderEntity.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'ProductDetailResp') {
      return ProductDetailResp.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'OrderDetailEntity') {
      return OrderDetailEntity.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'AddressEntity') {
      return AddressEntity.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'ReviewEntity') {
      return ReviewEntity.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'MultipleOrderResp') {
      return MultipleOrderResp.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'WebViewPaymentExtra') {
      return WebViewPaymentExtra.fromJson(inputAsList[1] as String);
    }
    if (inputAsList[0] == 'ChatRoomEntity') {
      return ChatRoomEntity.fromJson(inputAsList[1] as String);
    }
    throw FormatException('Unable to parse input: $input');
  }
}

class _MyExtraEncoder extends Converter<Object?, Object?> {
  const _MyExtraEncoder();
  @override
  Object? convert(Object? input) {
    if (input == null) {
      return null;
    }
    switch (input) {
      case String _ || Uri _ || DateTime _ || bool _ || double _ || num _ || int _:
        return input;
      case UserInfoEntity _:
        return <Object?>[
          'UserInfoEntity',
          input.toJson(),
        ];
      case ProductEntity _:
        return <Object?>[
          'ProductEntity',
          (input).toJson(),
        ];
      case OrderEntity _:
        return <Object?>[
          'OrderEntity',
          (input).toJson(),
        ];
      case ProductDetailResp _:
        return <Object?>[
          'ProductDetailResp',
          (input).toJson(),
        ];
      case OrderDetailEntity _:
        return <Object?>[
          'OrderDetailEntity',
          (input).toJson(),
        ];
      case AddressEntity _:
        return <Object?>[
          'AddressEntity',
          (input).toJson(),
        ];
      case ReviewEntity _:
        return <Object?>[
          'ReviewEntity',
          (input).toJson(),
        ];
      case MultipleOrderResp _:
        return <Object?>[
          'MultipleOrderResp',
          (input).toJson(),
        ];
      case WebViewPaymentExtra _:
        return <Object?>[
          'WebViewPaymentExtra',
          (input).toJson(),
        ];
      case ChatRoomEntity _:
        return <Object?>[
          'ChatRoomEntity',
          (input).toJson(),
        ];
      default:
        throw FormatException('Cannot encode type ${input.runtimeType}');
    }
  }
}
