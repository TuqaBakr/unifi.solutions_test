import 'package:dio/dio.dart';

import '../data/data_sources/local.dart';


class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {

    // 1. تحديد مسارات التسجيل والدخول
    final String path = options.path;
    final bool isAuthPath = path.contains('/user/register') || path.contains('/user/login');

    // 2. إذا كان الطلب تسجيل أو دخول، تخطى إضافة التوكن
    if (isAuthPath) {
      return handler.next(options);
    }

    // 3. محاولة قراءة التوكن بأمان (يجب تحويل القيمة إلى String? بشكل صريح لأن getData تعيد dynamic)
    final String? token = LocalStorage.getData(key: 'token') as String?;

    if (token != null && token.isNotEmpty) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    handler.next(options);
  }
}