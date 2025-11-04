import 'package:flutter/material.dart';
import 'dart:math';

import '../native_service.dart';

String formatBytes(double bytes) {
  if (bytes <= 0) return "0 B";
  const List<String> suffixes = ["B", "KB", "MB", "GB", "TB"];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]} ${suffixes[i] == "GB" ? "" : " " }';
}

class NativeInfoScreen extends StatefulWidget {
  const NativeInfoScreen({super.key});

  @override
  State<NativeInfoScreen> createState() => _NativeInfoScreenState();
}

class _NativeInfoScreenState extends State<NativeInfoScreen> {
  final NativeService _nativeService = NativeService();

  String _storageInfo = 'Fetching storage info...';

  String _cameraPermissionStatus = 'Unknown';
  Color _permissionColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _fetchStorageInfo();
  }

  Future<void> _fetchStorageInfo() async {
    setState(() {
      _storageInfo = 'Fetching...';
    });
    try {
      final Map<String, double> info = await _nativeService.getStorageInfo();
      final freeGB = info['freeGB']!;
      final totalGB = info['totalGB']!;

      setState(() {
        final totalDisplay = totalGB.toStringAsFixed(1);
        final freeDisplay = freeGB.toStringAsFixed(1);
        _storageInfo = 'Storage: $freeDisplay GB free of $totalDisplay GB';
      });
    } catch (e) {
      setState(() {
        _storageInfo = 'Error fetching storage: ${e.toString()}';
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _cameraPermissionStatus = 'Requesting...';
      _permissionColor = Colors.blue;
    });

    try {
      final String status = await _nativeService.requestCameraPermission();

      Color color;
      switch (status) {
        case 'granted':
          color = Colors.green;
          break;
        case 'denied':
          color = Colors.orange;
          break;
        case 'restricted':
        case 'permanentlyDenied':
          color = Colors.red;
          break;
        default:
          color = Colors.grey;
      }

      setState(() {
        _cameraPermissionStatus = status.replaceAllMapped(
            RegExp(r'([A-Z])'), (m) => ' ${m.group(0)!.toLowerCase()}'
        ).trim();
        _permissionColor = color;
      });

    } catch (e) {
      setState(() {
        _cameraPermissionStatus = 'Error: ${e.toString()}';
        _permissionColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Integration Demo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Device Storage Info (StatFs/URLResourceValues)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 20),
                      Text(
                        _storageInfo,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _fetchStorageInfo,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Storage'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Native Camera Permission',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Status: ', style: TextStyle(fontSize: 16)),
                          Text(
                            _cameraPermissionStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _permissionColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _requestPermission,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Request Camera Permission Natively'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
