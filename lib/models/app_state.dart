import 'package:flutter/foundation.dart';
import 'sound_event.dart';

class AppState {
  static final AppState _instance = AppState._();
  factory AppState() => _instance;
  AppState._();

  // ---- 监听机制 ----
  final List<VoidCallback> _listeners = [];
  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
  void notifyListeners() {
    for (final l in _listeners) {
      l();
    }
  }

  // ---- 参数页 ----
  double intensity = 0.65;
  double duration = 0.5;
  double sensitivity = 0.68;
  int selectedPreset = -1;

  // ---- 蓝牙连接 ----
  bool isConnected = false;
  String deviceName = 'SoundTrace ESP32-S3';
  String deviceId = 'ST-P0';

  // ---- 我的设备 ----
  String customDeviceName = '我的声迹';
  int batteryLevel = 86;
  String firmwareVersion = 'v0.9.4-beta';
  String serialNumber = 'STP0-24A8C31';

  // ---- 用户资料 ----
  String nickname = '声迹体验者';
  String gender = '未设置';
  String region = '未设置';
  String phone = '138****2026';
  String experimentId = 'P0-024';
  String avatarPath = '';

  // ---- 登录状态 ----
  bool loggedIn = false;

  // ---- 通知设置 ----
  final List<String> allNotifyTypes = [
    '车辆鸣笛',
    '警报声',
    '自行车铃',
    '门铃声',
    '人声呼叫',
    '犬吠声',
  ];
  final Set<String> enabledNotifyTypes = {};

  bool isNotifyEnabled(String type) => enabledNotifyTypes.contains(type);

  // ---- 声音事件 ----
  final List<SoundEvent> events = [];
}