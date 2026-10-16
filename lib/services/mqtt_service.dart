import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/app_state.dart';
import '../models/sound_event.dart';

class MqttService {
  static final MqttService _instance = MqttService._();
  factory MqttService() => _instance;
  MqttService._();

  final appState = AppState();

  MqttServerClient? _client;
  bool _connected = false;

  bool get isConnected => _connected;

  // 队友给的 Broker 地址
  static const _broker = 'fa1df1e0.ala.cn-shenzhen.emqxsl.cn';
  static const _clientId = 'soundtrace_app_001';
  static const _topic = 'soundtrace/events';

  Future<void> connect() async {
    if (kIsWeb) {
      debugPrint('Web 平台跳过 MQTT 连接');
      return;
    }
    if (_client != null) return;

    final MqttServerClient client;

    if (kIsWeb) {
      // Web：用 WebSocket，避开 TLS SecurityContext
      client = MqttServerClient.withPort(
        _broker,
        _clientId,
        8084,
      );
      client.useWebSocket = true;
      client.secure = false;
    } else {
      // 手机：原生 MQTT over TLS
      client = MqttServerClient.withPort(
        _broker,
        _clientId,
        8883,
      );
      client.useWebSocket = false;
      client.secure = true;
    }

    client.keepAlivePeriod = 30;
    client.logging(on: true);
    client.autoReconnect = true;
    client.onAutoReconnect = () {
      debugPrint('MQTT 自动重连中...');
    };

    client.onConnected = () {
      debugPrint('MQTT 已连接');
      _connected = true;
      client.subscribe(_topic, MqttQos.atMostOnce);
    };

    client.onDisconnected = () {
      debugPrint('MQTT 已断开');
      _connected = false;
    };

    client.updates!.listen((events) {
      for (final e in events) {
        final payload = e.payload as MqttPublishMessage;
        final msg = MqttPublishPayload.bytesToStringAsString(
            payload.payload.message);
        _handleMessage(msg);
      }
    });

  _client = client;
  try {
    await client.connect();
  } catch (e) {
    debugPrint('MQTT 连接失败: $e');
  }
}

  void _handleMessage(String raw) {
    debugPrint('收到 MQTT: $raw');
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;

      final soundType = (json['soundType'] ?? 'unknown').toString();
      final direction = (json['direction'] ?? 0) as int;
      final confidence =
          (json['confidence'] as num?)?.toDouble() ?? 1.0;
      final level = (json['level'] ?? 'normal').toString();
      final ts = (json['timestamp'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch;

      final event = _buildEvent(
        soundType: soundType,
        direction: direction,
        confidence: confidence,
        level: level,
        timestamp: ts,
      );

      appState.events.add(event);
      appState.notifyListeners();
    } catch (e) {
      debugPrint('JSON 解析失败: $e');
    }
  }

  SoundEvent _buildEvent({
    required String soundType,
    required int direction,
    required double confidence,
    required String level,
    required int timestamp,
  }) {
    final meta = _soundMeta(soundType);
    final levelMeta = _levelMeta(level);
    final dirText = _directionText(direction);

    return SoundEvent(
      icon: meta.icon,
      iconColor: meta.color,
      iconBg: meta.bg,
      level: levelMeta.name,
      levelColor: levelMeta.color,
      levelBg: levelMeta.bg,
      title: meta.title,
      direction: '$dirText $direction°',
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  _SoundMeta _soundMeta(String type) {
    switch (type) {
      case 'car_horn':
        return const _SoundMeta(
          title: '车辆鸣笛',
          icon: Icons.directions_car,
          color: Color(0xFFD48A8A),
          bg: Color(0xFFFCE8E8),
        );
      case 'alarm':
        return const _SoundMeta(
          title: '警报声',
          icon: Icons.warning_amber,
          color: Color(0xFFD48A8A),
          bg: Color(0xFFFCE8E8),
        );
      case 'bicycle_bell':
        return const _SoundMeta(
          title: '自行车铃',
          icon: Icons.notifications_none,
          color: Color(0xFFE0C08A),
          bg: Color(0xFFFBF3E0),
        );
      case 'doorbell':
        return const _SoundMeta(
          title: '门铃声',
          icon: Icons.doorbell_outlined,
          color: Color(0xFFE0C08A),
          bg: Color(0xFFFBF3E0),
        );
      case 'voice':
        return const _SoundMeta(
          title: '人声呼叫',
          icon: Icons.record_voice_over,
          color: Color(0xFF8AB8D4),
          bg: Color(0xFFE8F0F8),
        );
      case 'dog':
        return const _SoundMeta(
          title: '犬吠声',
          icon: Icons.pets,
          color: Color(0xFF8AB8D4),
          bg: Color(0xFFE8F0F8),
        );
      default:
        return const _SoundMeta(
          title: '未知声音',
          icon: Icons.help_outline,
          color: Color(0xFFB0A0C8),
          bg: Color(0xFFF0EAF8),
        );
    }
  }

  _LevelMeta _levelMeta(String level) {
    switch (level) {
      case 'high':
        return const _LevelMeta(
          name: '高危',
          color: Color(0xFFD48A8A),
          bg: Color(0xFFFCE8E8),
        );
      case 'medium':
        return const _LevelMeta(
          name: '注意',
          color: Color(0xFFE0C08A),
          bg: Color(0xFFFBF3E0),
        );
      default:
        return const _LevelMeta(
          name: '常规',
          color: Color(0xFF8AB8D4),
          bg: Color(0xFFE8F0F8),
        );
    }
  }

  String _directionText(int angle) {
    final a = angle % 360;
    if (a >= 337 || a < 23) return '正前方';
    if (a < 67) return '右前方';
    if (a < 113) return '右侧';
    if (a < 157) return '右后方';
    if (a < 203) return '后方';
    if (a < 247) return '左后方';
    if (a < 293) return '左侧';
    if (a < 337) return '左前方';
    return '正前方';
  }

  void disconnect() {
    _client?.disconnect();
    _client = null;
    _connected = false;
  }
}

class _SoundMeta {
  final String title;
  final IconData icon;
  final Color color;
  final Color bg;
  const _SoundMeta({
    required this.title,
    required this.icon,
    required this.color,
    required this.bg,
  });
}

class _LevelMeta {
  final String name;
  final Color color;
  final Color bg;
  const _LevelMeta({
    required this.name,
    required this.color,
    required this.bg,
  });
}