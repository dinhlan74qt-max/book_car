import 'package:dio/dio.dart';
import 'package:book_car/core/storage/user_local_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final UserLocalStorage storage;
  final void Function()? onSessionExpired;

  AuthInterceptor(this.storage, {this.onSessionExpired});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authHeader = await storage.getAuthHeader();
    if (authHeader != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = authHeader;
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await storage.clear(); // Xóa phiên đăng nhập hết hạn
      onSessionExpired?.call(); // Điều hướng về LoginScreen
    }
    return handler.next(err);
  }
}
