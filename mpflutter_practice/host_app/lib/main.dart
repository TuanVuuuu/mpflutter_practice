import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:host_app/models/miniapp_info.dart';
import 'package:mp_flutter_runtime/mp_flutter_runtime.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mini App Grid',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AppGridScreen(),
      );
}

class AppGridScreen extends StatefulWidget {
  const AppGridScreen({super.key});

  @override
  State<AppGridScreen> createState() => _AppGridScreenState();
}

class _AppGridScreenState extends State<AppGridScreen> {
  final Map<String, String> _miniAppResults = {};

  final MethodChannel channel =
      MethodChannel('com.example.miniapp/channel', const StandardMethodCodec());

  void sendToMiniApp(String data) {
    channel.invokeMethod('receiveData', data);
  }

  List<MiniAppInfo> get _apps => [
        MiniAppInfo(
          id: '1',
          mpkAssetFile: 'assets/build/mini_app_form.mpk',
          name: 'Mini App 1',
          icon: '',
          description: 'Mô tả app 1',
          initParams: '',
        ),
        MiniAppInfo(
          id: '2',
          mpkAssetFile: 'assets/build/mini_app_practice.mpk',
          name: 'Mini App 2',
          icon: '',
          description: 'Mô tả app 2',
          initParams: '',
        ),
      ];

  void _updateResult(String appId, String result) {
    setState(() {
      _miniAppResults[appId] = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host App Grid'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _apps.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final app = _apps[index];
            final result = _miniAppResults[app.id];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MiniAppPage(
                      appInfo: app,
                      data: 'sample_data',
                      onDataReceived: (name) {
                        print('Received from mini app ${app.id}: $name');
                        _updateResult(app.id, name);
                      },
                      latestName: result ?? '', // truyền giá trị mới nhất
                    ),
                  ),
                );
                // Gửi data cho mini app nếu cần khi mở lại
                if (result != null) {
                  sendToMiniApp(result);
                }
              },
              child: _buildAppCard(app, result),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppCard(MiniAppInfo app, String? result) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.app_registration, size: 30),
            const SizedBox(height: 12),
            Text(app.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(app.description,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            if (result != null) ...[
              const Divider(),
              Text('Result: $result',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ]
          ],
        ),
      ),
    );
  }
}

class MiniAppPage extends StatefulWidget {
  const MiniAppPage({
    super.key,
    required this.appInfo,
    required this.data,
    required this.onDataReceived,
    required this.latestName,
  });

  final MiniAppInfo appInfo;
  final String data;
  final void Function(String data) onDataReceived;
  final String latestName;

  @override
  State<MiniAppPage> createState() => _MiniAppPageState();
}

class _MiniAppPageState extends State<MiniAppPage> {
  Uint8List? mpkData;
  bool _dataSent = false;

  @override
  void initState() {
    super.initState();
    _loadMpk();
  }

  Future<void> _loadMpk() async {
    try {
      final byteData = await rootBundle.load(widget.appInfo.mpkAssetFile);
      mpkData = byteData.buffer.asUint8List();
      setState(() {});
    } catch (e) {
      print('Error loading MPK: $e');
    }
  }

  void _handleMiniAppMessage(dynamic message) {
    try {
      final decoded = json.decode(message);
      if (decoded['type'] == 'platform_channel') {
        final method = decoded['message']['beInvokeMethod'];
        final params = decoded['message']['beInvokeParams'];
        final channel = decoded['method'] ?? 'unknown';

        if (method == 'listen') {
          widget.onDataReceived(params['name'] ?? 'unknown');
        }

        print('[Host] Received on channel [$channel] → $method: $params');
      }
    } catch (e) {
      print('Failed to decode message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mpkData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading MPK file...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: MPMiniPageDebug(
        packageId: widget.appInfo.id,
        dev: false,
        mpk: mpkData,
        // Không cần truyền initParams nữa
        splash: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Launching mini app...'),
            ],
          ),
        ),
        onPostMessage: _handleMiniAppMessage,
      ),
    );
  }
}
