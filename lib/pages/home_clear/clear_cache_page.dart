import 'package:flutter/material.dart';
import '../../models/app_state.dart';

class ClearCachePage extends StatefulWidget {
  const ClearCachePage({super.key});

  @override
  State<ClearCachePage> createState() => _ClearCachePageState();
}

class _ClearCachePageState extends State<ClearCachePage> {
  final appState = AppState();

  void _confirm() {
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
              const Text('清除音频缓存？',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              const Text('此操作无法撤销，本地保存的音频片段将被永久删除。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE0D8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('取消',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          appState.events.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('缓存已清除')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A8AA8),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('确认清除'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Padding(
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
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.delete_outline,
                          size: 32, color: Color(0xFF6B6B8D)),
                    ),
                    const SizedBox(height: 20),
                    const Text('本地音频缓存',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3A3A5C))),
                    const SizedBox(height: 8),
                    Text(
                      '${(appState.events.length * 0.7 + 42.8).toStringAsFixed(1)} MB',
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B6B8D)),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        '清除后将删除设备产生的本地音频片段，但不会影响声音事件文字记录。',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFCE8E8),
                          foregroundColor: const Color(0xFFD48A8A),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('清除全部缓存'),
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