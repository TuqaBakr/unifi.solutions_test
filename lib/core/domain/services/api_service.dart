import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/models/base_response_model.dart';
import '../../typedefs.dart';

abstract class ApiServices {
  Future<BaseResponseModel> get(
      String path, {
        JSON? queryParams,
        CancelToken? cancelToken,
      });

  Future<BaseResponseModel> post(

      String path, {
        dynamic queryParams,
        dynamic body,
        FormData? formData,
        CancelToken? cancelToken,

      });
  Future<BaseResponseModel> patch(
      String path, {
        JSON? queryParams,
        JSON? body,
        FormData? formData,
        CancelToken? cancelToken,
      });

  Future<BaseResponseModel> postFiles(
      String path, {
        JSON? queryParams,
        JSON? body,
        FormData? formData,
        String? key,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      });
  Future<BaseResponseModel> postList(
      String path, {
        JSON? queryParams,
        List<dynamic>? body,
        FormData? formData,
        CancelToken? cancelToken,
      });
  Future downloadFile(
      BuildContext context,
      String path,
      String savePath,
      int fileId, {
        Map<String, dynamic>? queryParams,
        Map<String, dynamic>? body,
        FormData? formData,
      });
  Future<BaseResponseModel> put(
      String path, {
        JSON? queryParams,
        dynamic body,
        FormData? formData,
        CancelToken? cancelToken,
      });
  Future<BaseResponseModel> delete(
      String path, {
        JSON? queryParams,
        JSON? body,
        CancelToken? cancelToken,
      });
  Future<void> downloadFileWeb(
      String url,
      String fileName, {
        Map<String, dynamic>? queryParams,
      });



}
