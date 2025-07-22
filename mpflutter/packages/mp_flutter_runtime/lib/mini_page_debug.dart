part of './mp_flutter_runtime.dart';

class MPMiniPageDebug extends StatefulWidget {
  final Uint8List? mpk;
  final Widget? splash;
  final bool dev;
  final Map<String, dynamic>? initParams;
  final String? ip;
  final String packageId;
  final VoidCallback? onTap;
  final void Function(String message)? onPostMessage;

  const MPMiniPageDebug({
    Key? key,
    this.mpk,
    this.initParams,
    this.splash,
    this.dev = true,
    this.ip,
    this.onTap,
    required this.packageId,
    this.onPostMessage,
  }) : super(key: key);

  @override
  State<MPMiniPageDebug> createState() => _MPMiniPageDebugState();
}

class _MPMiniPageDebugState extends State<MPMiniPageDebug> {
  MPEngine? engine;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initEngine();
  }

  void initEngine() async {
    if (engine == null) {
      final engine = MPEngine(
        flutterContext: context,
        onPostMessage: widget.onPostMessage,
      );

      if (widget.dev == true) {
        assert(widget.ip != null);
        engine.initWithDebuggerServerAddr('${widget.ip}:9898');
      } else {
        assert(widget.mpk != null);
        engine.initWithMpkData(widget.mpk!);
      }

      setState(() {
        this.engine = engine;
      });

      await Future.delayed(const Duration(milliseconds: 100));
      await engine.start();

      // ✅ Gửi initParams sau khi engine khởi động xong
      if (widget.initParams != null) {
        engine._sendMessage({
          'type': 'platform_channel',
          'message': {
            'event': 'methodCall',
            'method':
                'com.example.miniapp/channel', // thay bằng channel bạn đang dùng
            'beInvokeMethod': 'setInitParams',
            'beInvokeParams': widget.initParams,
          }
        });
      }
    }
  }

  @override
  dispose() {
    super.dispose();
    engine?.stop();
  }

  @override
  Widget build(BuildContext context) {
    if (engine == null && widget.splash != null) return widget.splash!;
    return MPPage(
      engine: engine!,
    );
  }
}
