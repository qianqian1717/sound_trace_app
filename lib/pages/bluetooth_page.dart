import 'package:flutter/material.dart';
import '../models/app_state.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final appState = AppState();
  bool _isScanning = false;

  void _toggleConnect() {
    setState(() {
      appState.isConnected = !appState.isConnected;
    });
    appState.notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appState.isConnected ? '设备连接成功' : '设备已断开'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _rescan() {
    setState(() => _isScanning = true);
    // 模拟扫描耗时；接 BLE 后换成真实扫描回调
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isScanning = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final connected = appState.isConnected;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chevron_left,
                      color: Color(0xFF3A3A5C)),
                ),
              ),
              const SizedBox(height: 24),

              // 顶部图标 + 文案
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: connected
                            ? const Color(0xFFE0F0E8).withValues(alpha: 0.5)
                            : const Color(0xFFF0EAF8).withValues(alpha: 0.5),
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.06),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Icon(
                            connected ? Icons.check : Icons.bluetooth,
                            size: 36,
                            color: connected
                                ? const Color(0xFF6BA88A)
                                : const Color(0xFF8A8AA8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      connected ? 'SoundTrace 已连接' : '连接你的 SoundTrace',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3A5C)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      connected ? '实时数据通信稳定' : '开启设备并保持在手机附近',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 附近设备标题
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('附近设备',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3A3A5C))),
                  GestureDetector(
                    onTap: _rescan,
                    child: Row(
                      children: const [
                        Icon(Icons.search, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('重新搜索',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 设备区域：扫描中 / 设备卡片
              if (_isScanning)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFFB0A0C8)),
                      ),
                      SizedBox(width: 12),
                      Text('正在搜索附近的蓝牙设备',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F2FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.phone_iphone,
                            size: 20, color: Color(0xFF6B6B8D)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appState.deviceName,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3A3A5C))),
                            const SizedBox(height: 2),
                            Text('信号良好 · ${appState.deviceId}',
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _toggleConnect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: connected
                              ? Colors.white
                              : const Color(0xFF8A8AA8),
                          foregroundColor: connected
                              ? const Color(0xFF8A8AA8)
                              : Colors.white,
                          side: connected
                              ? const BorderSide(color: Color(0xFFD0C0E8))
                              : BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          connected ? '断开' : '连接',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}