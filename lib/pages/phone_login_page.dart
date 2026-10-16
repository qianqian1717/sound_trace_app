import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/app_storage.dart';
import '../main.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final appState = AppState();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  String _fakeCode = '';
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  bool _validPhone(String phone) {
    return RegExp(r'^\d{11}$').hasMatch(phone);
  }

  void _sendCode() {
    final phone = _phoneCtrl.text.trim();
    if (!_validPhone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入 11 位手机号')),
      );
      return;
    }
    final code = (100000 + DateTime.now().millisecond * 7 % 900000)
        .toString()
        .substring(0, 6);
    setState(() {
      _fakeCode = code;
      setState(() {
        _fakeCode = code;
        _countdown = 60;    // ← 用 _countdown 替代了 _codeSent
      });
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('P0 模拟验证码：$code')),
    );
  }

  void _confirm() async {
    if (_codeCtrl.text.trim() != _fakeCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码不正确')),
      );
      return;
    }
    final phone = _phoneCtrl.text.trim();
    appState.phone = phone.length >= 8
        ? '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}'
        : phone;
    appState.loggedIn = true;
    await AppStorage.save();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _countdown == 0;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              const Text('手机号登录',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              const Text('P0 阶段使用模拟验证码',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '请输入手机号',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '验证码',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: canSend ? _sendCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSend
                          ? const Color(0xFFF0EAF8)
                          : const Color(0xFFE8E4F0),
                      foregroundColor: const Color(0xFF6B6B8D),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _countdown > 0 ? '$_countdown s' : '获取验证码',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A8AA8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('登录 / 注册'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}