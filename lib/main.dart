import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'pages/home_page.dart';
import 'pages/params_page.dart';
import 'pages/account_page.dart';
import 'pages/login_page.dart';
import 'models/app_state.dart';
import 'services/app_storage.dart';
import 'services/mqtt_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.load();

  // Web 上跳过 MQTT（mqtt_client 在 Web 上不支持 TLS）
  // 手机/桌面才连
  if (!kIsWeb) {
    MqttService().connect();
  }

  runApp(const SoundTraceApp());
}

class SoundTraceApp extends StatelessWidget {
  const SoundTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    return MaterialApp(
      title: 'SoundTrace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),
        useMaterial3: true,
      ),
      // 未登录 → 登录页；已登录 → 主界面
      home: appState.loggedIn ? const MainShell() : const LoginPage(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  List<Widget> get _pages => const [
        HomePage(),
        ParamsPage(),
        AccountPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF6B6B8D),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: '动态'),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: '参数'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '账户'),
        ],
      ),
    );
  }
}