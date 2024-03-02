import 'dart:convert';

import '../../features/auth/data/models/user_info_model.dart';
import '../../features/auth/domain/entities/user_info_entity.dart';

class UserInfoExtraCodec extends Codec<Object?, Object?> {
  /// Create a codec.
  const UserInfoExtraCodec();
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
      default:
        throw FormatException('Cannot encode type ${input.runtimeType}');
    }
  }
}
