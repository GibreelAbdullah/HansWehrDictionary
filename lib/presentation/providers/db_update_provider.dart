import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db_update_service.dart';

final dbUpdateProvider = FutureProvider<DbUpdateInfo?>((ref) => checkForDbUpdate());
