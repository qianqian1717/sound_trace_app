import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'bluetooth_page.dart';
import '../services/app_storage.dart';


class ParamsPage extends StatefulWidget {
  const ParamsPage({super.key});

  @override
  State<ParamsPage> createState() => _ParamsPageState();
}

class _ParamsPageState extends State<ParamsPage> {
  final appState = AppState();

  void _showNotConnectedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EAF8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.info_outline,
                    size: 24, color: Color(0xFF6B6B8D)),
              ),
              const SizedBox(height: 16),
              const Text('设备尚未连接',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              const Text(
                '参数需要通过蓝牙发送到声迹设备，请先前往蓝牙设置完成连接。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE0D8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('稍后再说',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BluetoothPage()),
                        ).then((_) => setState(() {})); // 回来后刷新连接状态
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8AA8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('前往连接'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goBluetooth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BluetoothPage()),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('设备调节',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 2),
                    Text('参数',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A5C))),
                  ],
                ),
                // 右上角状态胶囊，点击跳蓝牙页
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _goBluetooth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: appState.isConnected
                          ? const Color(0xFFE0F0E8)
                          : const Color(0xFFF0E6E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          appState.isConnected
                              ? Icons.bluetooth_connected
                              : Icons.bluetooth_disabled,
                          size: 16,
                          color: appState.isConnected
                              ? const Color(0xFF6BA88A)
                              : const Color(0xFFB07A7A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          appState.isConnected ? '已连接' : '未连接',
                          style: TextStyle(
                            fontSize: 13,
                            color: appState.isConnected
                                ? const Color(0xFF6BA88A)
                                : const Color(0xFFB07A7A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('快速设置',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 2),
                    Text('场景预设',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A5C))),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // 参数已经在 appState 里，这里只负责“提示已保存”
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('方案已保存')),
                    );
                  },
                  child: const Text('保存方案',
                      style: TextStyle(
                          fontSize: 12, color: Color(0xFF8AB8D4))),
                ),
              ],
            ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          appState.selectedPreset = 0;
                          appState.intensity = 0.85;
                          appState.duration = 0.4;
                          appState.sensitivity = 0.9;
                        });
                        AppStorage.save();
                      },
                      child: _presetCard(
                        icon: Icons.home_outlined,
                        title: '安静室内',
                        subtitle: '灵敏捕捉轻微声响',
                        selected: appState.selectedPreset == 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          appState.selectedPreset = 1;
                          appState.intensity = 0.6;
                          appState.duration = 0.5;
                          appState.sensitivity = 0.55;
                        });
                        AppStorage.save();
                      },
                      child: _presetCard(
                        icon: Icons.wb_sunny_outlined,
                        title: '嘈杂户外',
                        subtitle: '过滤复杂背景噪音',
                        selected: appState.selectedPreset == 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _sliderItem(
                    context,
                    '震动强度',
                    '调节设备触觉反馈力度',
                    '${(appState.intensity * 100).round()} %',
                    appState.intensity,
                    (v) => setState(() {
                      appState.intensity = v;
                      appState.selectedPreset = -1;
                    }),
                    (v) => AppStorage.save(),
                  ),
                  const Divider(height: 32, color: Color(0xFFF0EAF8)),
                  _sliderItem(
                    context,
                    '震动时长',
                    '设置单次反馈持续时间',
                    '${(appState.duration * 600).round()} ms',
                    appState.duration,
                    (v) => setState(() {
                      appState.duration = v;
                      appState.selectedPreset = -1;
                    }),
                    (v) => AppStorage.save(),
                  ),
                  const Divider(height: 32, color: Color(0xFFF0EAF8)),
                  _sliderItem(
                    context,
                    '定位灵敏度',
                    '调节微弱声音的检测能力',
                    '${(appState.sensitivity * 100).round()} %',
                    appState.sensitivity,
                    (v) => setState(() {
                      appState.sensitivity = v;
                      appState.selectedPreset = -1;
                    }),
                    (v) => AppStorage.save(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (!appState.isConnected) {
                    _showNotConnectedDialog();
                  } else {
                    // TODO: 接 BLE 后在这里下发参数给 ESP32
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('参数已发送到设备')),
                    );
                  }
                },
                icon: const Icon(Icons.bluetooth, size: 18),
                label: const Text('蓝牙下发参数'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A8AA8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    appState.intensity = 0.65;
                    appState.duration = 0.5;
                    appState.sensitivity = 0.68;
                    appState.selectedPreset = 0;
                  });
                  AppStorage.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已恢复默认参数')),
                  );
                },
                child: const Text('恢复默认参数',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF0EAF8) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? const Color(0xFFD0C0E8) : const Color(0xFFF0EAF8),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF6B6B8D)),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3A5C))),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _sliderItem(
    BuildContext context,
    String title,
    String subtitle,
    String value,
    double progress,
    ValueChanged<double> onChanged,
    ValueChanged<double> onChangeEnd, 
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3A5C))),
            Text(value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B6B8D))),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFFB0A0C8),
            inactiveTrackColor: const Color(0xFFF0EAF8),
            thumbColor: const Color(0xFFB0A0C8),
            overlayColor: const Color(0x33B0A0C8),
            trackHeight: 4,
          ),
          child: Slider(
            value: progress,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }
}