import 'package:flutter/material.dart';
import '../../models/app_state.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final appState = AppState();
  bool _renaming = false;
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: appState.customDeviceName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _toggleRename() {
    if (_renaming) {
      final v = _nameCtrl.text.trim();
      if (v.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('设备名不能为空')),
        );
        return;
      }
      appState.customDeviceName = v;
      setState(() => _renaming = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设备名已更新')),
      );
    } else {
      _nameCtrl.text = appState.customDeviceName;
      setState(() => _renaming = true);
    }
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

              // 顶部设备卡
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.phone_iphone,
                          size: 32, color: Color(0xFF6B6B8D)),
                    ),
                    const SizedBox(height: 16),
                    _renaming
                        ? TextField(
                            controller: _nameCtrl,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF7F5FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          )
                        : Text(appState.customDeviceName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3A3A5C))),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _toggleRename,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_renaming ? Icons.check : Icons.edit,
                              size: 14, color: const Color(0xFF8A8AA8)),
                          const SizedBox(width: 4),
                          Text(_renaming ? '保存' : '重命名',
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF8A8AA8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 信息列表
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _row(
                      '连接状态',
                      connected ? '已连接' : '未连接',
                      valueColor: connected
                          ? const Color(0xFF6BA88A)
                          : const Color(0xFFD48A8A),
                    ),
                    _divider(),
                    _row('设备电量', '${appState.batteryLevel}%',
                        valueColor: appState.batteryLevel < 20
                            ? const Color(0xFFD48A8A)
                            : null),
                    _divider(),
                    _row('固件版本', appState.firmwareVersion),
                    _divider(),
                    _row('设备序列号', appState.serialNumber),
                  ],
                ),
              ),

              // 低电量提醒
              if (appState.batteryLevel < 20 && connected) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE8E8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.battery_alert,
                          size: 18, color: Color(0xFFD48A8A)),
                      SizedBox(width: 8),
                      Text('设备电量低，请及时充电',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF8A4A4A))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? const Color(0xFF3A3A5C))),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: Color(0xFFF0EAF8));
}