import 'package:flutter/material.dart';
import 'phone_login_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              // 图标
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A8AA8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text('迹',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('登录 SoundTrace',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              const Text('登录后同步你的参数与历史记录',
                  style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PhoneLoginPage()),
                    );
                    // 登录成功后 PhoneLoginPage 会修改 appState.loggedIn
                    // 这里 pop 回来后由外层根据 loggedIn 决定是否跳转
                  },
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
              const Spacer(),
              const Text('继续即表示同意《用户协议》与《隐私政策》',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}