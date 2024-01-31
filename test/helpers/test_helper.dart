import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_vtv/core/helpers/secure_storage_helper.dart';
import 'package:flutter_vtv/features/auth/data/data_sources/auth_data_source.dart';
import 'package:flutter_vtv/features/auth/domain/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    AuthRepository,
    AuthDataSource,
    SecureStorageHelper,
    Connectivity,
  ],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
  ],
)
void main() {}
