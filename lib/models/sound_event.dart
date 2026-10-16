import 'package:flutter/material.dart';

class SoundEvent {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String level;
  final Color levelColor;
  final Color levelBg;
  final String title;
  final String direction;
  final DateTime timestamp; // 事件发生时间

  const SoundEvent({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.level,
    required this.levelColor,
    required this.levelBg,
    required this.title,
    required this.direction,
    required this.timestamp,
  });
}