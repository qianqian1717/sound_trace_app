import 'package:flutter/material.dart';
import '../../models/app_state.dart';

class ProfileGenderPage extends StatefulWidget {
  const ProfileGenderPage({super.key});

  @override
  State<ProfileGenderPage> createState() => _ProfileGenderPageState();
}

class _ProfileGenderPageState extends State<ProfileGenderPage> {
  final appState = AppState();
  late String _current;

  final List<String> _options = ['男', '女', '不愿透露'];

  @override
  void initState() {
    super.initState();
    _current = appState.gender;
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
              const SizedBox(height: 24),
              const Text('性别',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _options.length; i++) ...[
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() => _current = _options[i]);
                          appState.gender = _options[i];
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Text(_options[i],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF3A3A5C))),
                              const Spacer(),
                              if (_current == _options[i])
                                const Icon(Icons.check,
                                    size: 18, color: Color(0xFF8A8AA8)),
                            ],
                          ),
                        ),
                      ),
                      if (i != _options.length - 1)
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
    );
  }
}