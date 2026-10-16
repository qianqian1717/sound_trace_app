import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/sound_event.dart';
import '../painters/sound_radar_painter.dart';
import 'bluetooth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final appState = AppState();

  @override
  void initState() {
    super.initState();
    appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  List<SoundEvent> get _visibleEvents =>
      appState.events.where((e) => appState.isNotifyEnabled(e.title)).toList();

  double _parseAngle(String direction) {
    final match = RegExp(r'(\d+)').firstMatch(direction);
    if (match == null) return 0;
    final deg = double.tryParse(match.group(1)!) ?? 0;
    return deg % 360;
  }

  Color _levelColor(String level) {
    switch (level) {
      case '高危':
        return const Color(0xFFD48A8A);
      case '注意':
        return const Color(0xFFE0C08A);
      default:
        return const Color(0xFF8AB8D4);
    }
  }

  void _goBluetooth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BluetoothPage()),
    );
  }

  void _clearEvents() {
    setState(() => appState.events.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已清除声音事件记录')),
    );
  }

  // 调试用：点击标题添加所有模拟事件，等 BLE 通了之后删掉
  void _addMockEvent() {
    setState(() {
      appState.events.addAll([
        SoundEvent(
          icon: Icons.directions_car,
          iconColor: const Color(0xFFD48A8A),
          iconBg: const Color(0xFFFCE8E8),
          level: '高危',
          levelColor: const Color(0xFFD48A8A),
          levelBg: const Color(0xFFFCE8E8),
          title: '车辆鸣笛',
          direction: '后方 172°',
          timestamp: DateTime.now(),
        ),
        SoundEvent(
          icon: Icons.warning_amber,
          iconColor: const Color(0xFFD48A8A),
          iconBg: const Color(0xFFFCE8E8),
          level: '高危',
          levelColor: const Color(0xFFD48A8A),
          levelBg: const Color(0xFFFCE8E8),
          title: '警报声',
          direction: '右后方 150°',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        SoundEvent(
          icon: Icons.notifications_none,
          iconColor: const Color(0xFFE0C08A),
          iconBg: const Color(0xFFFBF3E0),
          level: '注意',
          levelColor: const Color(0xFFE0C08A),
          levelBg: const Color(0xFFFBF3E0),
          title: '自行车铃',
          direction: '左侧 86°',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        SoundEvent(
          icon: Icons.doorbell_outlined,
          iconColor: const Color(0xFFE0C08A),
          iconBg: const Color(0xFFFBF3E0),
          level: '注意',
          levelColor: const Color(0xFFE0C08A),
          levelBg: const Color(0xFFFBF3E0),
          title: '门铃声',
          direction: '正前方 5°',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        SoundEvent(
          icon: Icons.record_voice_over,
          iconColor: const Color(0xFF8AB8D4),
          iconBg: const Color(0xFFE8F0F8),
          level: '常规',
          levelColor: const Color(0xFF8AB8D4),
          levelBg: const Color(0xFFE8F0F8),
          title: '人声呼叫',
          direction: '右前方 48°',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        SoundEvent(
          icon: Icons.pets,
          iconColor: const Color(0xFF8AB8D4),
          iconBg: const Color(0xFFE8F0F8),
          level: '常规',
          levelColor: const Color(0xFF8AB8D4),
          levelBg: const Color(0xFFE8F0F8),
          title: '犬吠声',
          direction: '左前方 320°',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ]);
    });
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
                GestureDetector(
                  onTap: _addMockEvent,
                  child: const Text('SoundTrace',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3A5C))),
                ),
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
                                  : const Color(0xFFB07A7A)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (!appState.isConnected)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goBluetooth,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE8E8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.bluetooth,
                            size: 20, color: Color(0xFFD48A8A)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('蓝牙连接已断开',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8A4A4A))),
                            SizedBox(height: 2),
                            Text('连接设备后才能接收实时声音数据',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFAA7A7A))),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: Color(0xFFAA7A7A)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // 仪表盘
            Container(
              height: 320,
              width: double.infinity,
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(56, 70, 56, 70),
                      child: CustomPaint(
                        painter: SoundRadarPainter(
                          dots: _visibleEvents.map((e) {
                            return RadarDot(
                              angle: _parseAngle(e.direction),
                              color: _levelColor(e.level),
                              label:
                                  '${e.direction.replaceAll('°', '')}° · ${e.level}',
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    top: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('实时监测',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(height: 2),
                        Text('环境声场',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3A3A5C))),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EAF8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        appState.isConnected ? '信噪比 17.7 dB' : '信噪比 -- dB',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF6B6B8D)),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 14,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('前',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ),
                  const Positioned(
                    bottom: 44,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('后',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('左',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ),
                  const Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text('右',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 16,
                    child: Row(
                      children: [
                        _legendDot(const Color(0xFFD48A8A), '高危'),
                        const SizedBox(width: 12),
                        _legendDot(const Color(0xFFE0C08A), '注意'),
                        const SizedBox(width: 12),
                        _legendDot(const Color(0xFF8AB8D4), '常规'),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 16,
                    child: Text(
                      appState.isConnected ? '响应 42 毫秒' : '等待设备连接',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 声音事件标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('最近检测',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 2),
                    Text('声音事件',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A5C))),
                  ],
                ),
                TextButton.icon(
                  onPressed: _visibleEvents.isEmpty ? null : _clearEvents,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label:
                      const Text('清除记录', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_visibleEvents.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('暂无声音事件',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
              )
            else
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _visibleEvents.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final e = _visibleEvents[index];
                    return _eventCard(
                      icon: e.icon,
                      iconColor: e.iconColor,
                      iconBg: e.iconBg,
                      level: e.level,
                      levelColor: e.levelColor,
                      levelBg: e.levelBg,
                      title: e.title,
                      direction: e.direction,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _eventCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String level,
    required Color levelColor,
    required Color levelBg,
    required String title,
    required String direction,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: levelBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(level,
                    style: TextStyle(fontSize: 10, color: levelColor)),
              ),
            ],
          ),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3A5C))),
          const SizedBox(height: 4),
          Text(direction,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}