import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../models/sound_event.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final appState = AppState();
  int _tab = 0; // 0=今天 1=昨天 2=本周

  List<SoundEvent> _filtered() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    return appState.events.where((e) {
      final d =
          DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
      switch (_tab) {
        case 0:
          return d == today;
        case 1:
          return d == yesterday;
        case 2:
          return d.isAfter(weekAgo) && d.isBefore(today);
        default:
          return false;
      }
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                  const Text('历史记录',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3A5C))),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EAF8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _tabBtn('今天', 0),
                        _tabBtn('昨天', 1),
                        _tabBtn('本周', 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('暂无记录',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final e = list[i];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: e.iconBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(e.icon,
                                    size: 18, color: e.iconColor),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(e.title,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF3A3A5C))),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${e.direction} · ${_formatTime(e.timestamp)}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      active ? FontWeight.w600 : FontWeight.normal,
                  color: active
                      ? const Color(0xFF3A3A5C)
                      : Colors.grey)),
        ),
      ),
    );
  }
}