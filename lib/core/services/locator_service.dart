import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator_service.config.dart';

final di = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await di.init();

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  // @singleton
  // FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin => FlutterLocalNotificationsPlugin();
}
