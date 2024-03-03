import 'dart:convert';

import '../../features/auth/data/models/user_info_model.dart';
import '../../features/auth/domain/entities/user_info_entity.dart';
import '../../features/home/domain/entities/product_entity.dart';

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
    if (inputAsList[0] == 'UserInfoEntity') {
      return UserInfoModel.fromJson(inputAsList[1] as String).toEntity();
    }
    if (inputAsList[0] == 'ProductEntity') {
      return ProductEntity.fromJson(inputAsList[1] as String);
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
      case UserInfoEntity _:
        return <Object?>[
          'UserInfoEntity',
          UserInfoModel.fromEntity(input).toJson(),
        ];
      case ProductEntity _:
        return <Object?>[
          'ProductEntity',
          (input).toJson(),
        ];
      default:
        throw FormatException('Cannot encode type ${input.runtimeType}');
    }
  }
}
