import 'package:flutter/material.dart';
import '../../models/app_state.dart';

class ProfilePhonePage extends StatefulWidget {
  const ProfilePhonePage({super.key});

  @override
  State<ProfilePhonePage> createState() => _ProfilePhonePageState();
}

class _ProfilePhonePageState extends State<ProfilePhonePage> {
  final appState = AppState();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  bool _codeSent = false;
  String _fakeCode = '';

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _sendCode() {
    final phone = _phoneCtrl.text.trim();
    if (phone.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的手机号')),
      );
      return;
    }
    // P0：假验证码，打印到界面，不真发短信
    final code = (100000 + DateTime.now().millisecond * 7 % 900000)
        .toString()
        .substring(0, 6);
    setState(() {
      _fakeCode = code;
      _codeSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('P0 模拟验证码：$code')),
    );
  }

  void _confirm() {
    if (_codeCtrl.text.trim() != _fakeCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码不正确')),
      );
      return;
    }
    final phone = _phoneCtrl.text.trim();
    appState.phone =
        phone.length >= 8 ? '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}' : phone;
    Navigator.pop(context);
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
              const Text('更换手机号',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              Text('当前：${appState.phone}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 24),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '请输入新手机号',
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
                    onPressed: _sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0EAF8),
                      foregroundColor: const Color(0xFF6B6B8D),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(_codeSent ? '重新发送' : '获取验证码',
                        style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A8AA8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('确认更换'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}