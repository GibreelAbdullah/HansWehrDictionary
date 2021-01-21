import 'package:get_it/get_it.dart';
import 'package:search/services/LocalStorageService.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);
}
