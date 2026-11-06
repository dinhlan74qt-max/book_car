import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// File này chưa có, lát nữa build_runner sẽ TỰ ĐỘNG SINH RA:
import 'injection_container.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  sl.init(); // Gọi hàm mở rộng được build_runner sinh ra trong file .config.dart
}
