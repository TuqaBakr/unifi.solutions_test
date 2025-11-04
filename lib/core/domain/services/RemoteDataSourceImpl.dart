import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../data/models/base_response_model.dart';
import '../../typedefs.dart';
import 'RemoteDataSource.dart';
typedef ProgressCallback = void Function(int sent, int total);


class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  RemoteDataSourceImpl({required this.dio});

  @override
  Future<BaseResponseModel> delete(
      String path, {
        JSON? queryParams,
        JSON? body,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: queryParams,
        data: body,
        cancelToken: cancelToken,
      );
      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel> get(
      String path, {
        JSON? queryParams,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel> post(
      String path, {
        dynamic queryParams,
        dynamic body,
        FormData? formData,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.post(
        path,
        queryParameters: queryParams,
        data: formData ?? body,
        cancelToken: cancelToken,
      );
      debugPrint(response.headers.value('Authorization'));
      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel> patch(
      String path, {
        JSON? queryParams,
        JSON? body,
        FormData? formData,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.patch(
        path,
        queryParameters: queryParams,
        data: formData ?? body,
        cancelToken: cancelToken,
      );

      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }


  @override
  Future<BaseResponseModel> postFiles(
      String path, {
        JSON? queryParams,
        JSON? body,
        String? key, // (unused here but kept for compatibility)
        FormData? formData,
        Map<String, dynamic>? extraHeaders,
        CancelToken? cancelToken,

        // NEW: expose progress callbacks
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      // Enforce either formData or body, not both
      assert(!(formData != null && body != null),
      'Provide either `formData` (multipart) or `body` (JSON), not both.');

      final headers = <String, dynamic>{
        ...dio.options.headers,
        ...?extraHeaders,
        // If multipart, let Dio set boundary automatically
        if (formData != null) 'Content-Type': 'multipart/form-data',
      };

      final response = await dio.post(
        path,
        data: formData ?? body,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(headers: headers),
        onSendProgress: (sent, total) {
          // forward the raw bytes up to the caller
          if (onSendProgress != null) onSendProgress(sent, total);
          // optional: dev log
          assert(() {
            if (total > 0) {
              debugPrint('Upload ${((sent / total) * 100).clamp(0, 100).toStringAsFixed(0)}%');
            }
            return true;
          }());
        },
        onReceiveProgress: (received, total) {
          if (onReceiveProgress != null) onReceiveProgress(received, total);
          assert(() {
            if (total > 0) {
              debugPrint('Download ${((received / total) * 100).clamp(0, 100).toStringAsFixed(0)}%');
            }
            return true;
          }());
        },
      );

      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      // Prefer server body if present, otherwise surface Dio error cleanly
      if (e.response != null) {
        final wrapped = _handleResponseAsJson(e.response!);
        throw Exception(
          'API POST error: ${wrapped.body['code'] ?? e.response?.statusCode} - ${wrapped.body['message'] ?? e.message}',
        );
      }
      // network/timeout/cancel cases
      if (e.type == DioExceptionType.cancel) {
        throw Exception('Request cancelled');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Network timeout');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Non-Dio errors
      throw Exception('Unexpected error: $e');
    }
  }


  @override
  Future<BaseResponseModel> postList(
      String path, {
        JSON? queryParams,
        List? body,
        FormData? formData,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.post(
        path,
        queryParameters: queryParams,
        data: formData ?? body,
        cancelToken: cancelToken,
      );
      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel> put(
      String path, {
        JSON? queryParams,
        dynamic body,
        FormData? formData,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.put(
        path,
        queryParameters: queryParams,
        data: formData ?? body,
        cancelToken: cancelToken,
      );
      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }

  BaseResponseModel _handleResponseAsJson(Response response) {
    debugPrint(response.headers.toString());
    return BaseResponseModel(
      body: response.data,
      headers: response.headers.map,
    );
  }

  @override
  Future downloadFile(
      BuildContext context,
      String path,
      String savePath,
      int fileId, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? body,
        FormData? formData,
      }) async {
    try {
      final response = await dio.download(
        path,
        savePath,
        onReceiveProgress: (count, total) {},
      );
      return _handleResponseAsJson(response);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> downloadFileWeb(String url, String fileName, {Map<String, dynamic>? queryParams}) {
    // TODO: implement downloadFileWeb
    throw UnimplementedError();
  }





}
