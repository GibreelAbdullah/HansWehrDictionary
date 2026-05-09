import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initDatabaseFactory() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
