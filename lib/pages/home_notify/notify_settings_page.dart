import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../services/app_storage.dart';

class NotifySettingsPage extends StatefulWidget {
  const NotifySettingsPage({super.key});

  @override
  State<NotifySettingsPage> createState() => _NotifySettingsPageState();
}

class _NotifySettingsPageState extends State<NotifySettingsPage> {
  final appState = AppState();
  late Set<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = Set<String>.from(appState.enabledNotifyTypes);
  }

  void _toggle(String type) {
    setState(() {
      if (_tempSelected.contains(type)) {
        _tempSelected.remove(type);
      } else {
        _tempSelected.add(type);
      }
    });
  }

  void _save() {
    appState.enabledNotifyTypes
      ..clear()
      ..addAll(_tempSelected);
    AppStorage.save();   // ← 加这一行
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已保存通知设置')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final types = appState.allNotifyTypes;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    const Text('通知设置',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A5C))),
                    const SizedBox(height: 8),
                    const Text('选择需要通过头戴设备进行震动提醒的声音类型。',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
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
                          for (int i = 0; i < types.length; i++) ...[
                            _typeRow(types[i]),
                            if (i != types.length - 1)
                              const Divider(
                                  height: 1, color: Color(0xFFF0EAF8)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A8AA8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('保存'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeRow(String type) {
    final enabled = _tempSelected.contains(type);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _toggle(type),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(type,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3A3A5C))),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: enabled
                    ? const Color(0xFF8A8AA8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: enabled
                      ? const Color(0xFF8A8AA8)
                      : const Color(0xFFD0D0D8),
                  width: 1.5,
                ),
              ),
              child: enabled
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}