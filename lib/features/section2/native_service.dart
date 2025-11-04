import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativeService {
  static const MethodChannel _channel = MethodChannel('com.app/native_utils');


  Future<Map<String, double>> getStorageInfo() async {
    try {

      final Map<Object?, Object?> result = await _channel.invokeMethod('getStorageInfo');

      final totalBytes = (result['totalBytes'] as num).toDouble();
      final freeBytes = (result['freeBytes'] as num).toDouble();

      const double bytesToGB = 1024 * 1024 * 1024;

      return {
        'totalGB': totalBytes / bytesToGB,
        'freeGB': freeBytes / bytesToGB,
      };

    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to get storage info: ${e.message}");
      }
      throw Exception("Native call failed: ${e.message}");
    }
  }

  Future<String> requestCameraPermission() async {
    try {
      final String status = await _channel.invokeMethod('requestCameraPermission');
      return status;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to request camera permission: ${e.message}");
      }
      return "Error: ${e.message}";
    }
  }
}
