import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_vtv/core/notification/firebase_cloud_messaging_manager.dart';
import 'package:flutter_vtv/features/auth/data/data_sources/auth_data_source.dart';
import 'package:flutter_vtv/features/auth/domain/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:vtv_common/vtv_common.dart';

@GenerateMocks(
  [
    AuthRepository,
    AuthDataSource,
    SecureStorageHelper,
    Connectivity,
    FirebaseCloudMessagingManager,
  ],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
  ],
)
void main() {}
