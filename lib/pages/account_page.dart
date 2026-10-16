import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../services/app_storage.dart';
import 'bluetooth_page.dart';
import 'home_profile/profile_edit_page.dart';
import 'home_device/device_info_page.dart';
import 'home_history/history_page.dart';
import 'home_clear/clear_cache_page.dart';
import 'home_about/about_page.dart';
import 'home_notify/notify_settings_page.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final appState = AppState();

  void _push(BuildContext context, Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    setState(() {});
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE8E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.logout,
                    size: 24, color: Color(0xFFD48A8A)),
              ),
              const SizedBox(height: 16),
              const Text('确认退出登录？',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              const Text('退出后需要重新登录才能同步数据。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD48A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('确认退出'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm != true) return;
    await AppStorage.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('个人中心',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 2),
                Text('账户',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A3A5C))),
              ],
            ),
            const SizedBox(height: 24),

            // 用户卡
            GestureDetector(
              onTap: () => _push(context, const ProfileEditPage()),
              child: _card(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A8AA8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('迹',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appState.nickname,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3A3A5C))),
                        const SizedBox(height: 2),
                        Text('实验编号 ${appState.experimentId}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 当前设备卡
            GestureDetector(
              onTap: () => _push(context, const BluetoothPage()),
              child: _card(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EAF8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.devices_other,
                          size: 22, color: Color(0xFF6B6B8D)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('当前设备',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            appState.isConnected
                                ? '${appState.customDeviceName} 已连接'
                                : '${appState.customDeviceName} 尚未连接',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3A3A5C)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appState.isConnected
                                ? '实时数据通信稳定'
                                : '点击搜索并连接附近设备',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: appState.isConnected
                            ? const Color(0xFF6BA88A)
                            : const Color(0xFFD48A8A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 设置列表
            _card(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _settingItem(
                    icon: Icons.person_outline,
                    title: '用户',
                    subtitle: '登录注册与个人信息',
                    onTap: () => _push(context, const ProfileEditPage()),
                  ),
                  _divider(),
                  _settingItem(
                    icon: Icons.bluetooth,
                    title: '蓝牙',
                    subtitle:
                        appState.isConnected ? '设备已连接' : '设备未连接',
                    showDot: !appState.isConnected,
                    onTap: () => _push(context, const BluetoothPage()),
                  ),
                  _divider(),
                  _settingItem(
                    icon: Icons.phone_iphone,
                    title: '我的设备',
                    subtitle: '设备信息与重命名',
                    onTap: () => _push(context, const DeviceInfoPage()),
                  ),
                  _divider(),
                  _settingItem(
                    icon: Icons.notifications_none,
                    title: '通知设置',
                    subtitle: appState.enabledNotifyTypes.isEmpty
                        ? '尚未选择提醒类型'
                        : '已启用 ${appState.enabledNotifyTypes.length} 个类型',
                    onTap: () => _push(context, const NotifySettingsPage()),
                  ),
                  _divider(),
                  _settingItem(
                    icon: Icons.history,
                    title: '历史记录',
                    subtitle: '完整声音事件库',
                    onTap: () => _push(context, const HistoryPage()),
                  ),
                  _divider(),
                  _settingItem(
                    icon: Icons.delete_outline,
                    title: '清除缓存',
                    subtitle: '清理本地音频记录',
                    onTap: () => _push(context, const ClearCachePage()),
                  ),
                  _divider(),
                  _settingItem(
                    icon: Icons.info_outline,
                    title: '关于',
                    subtitle: '版本、帮助与反馈',
                    onTap: () => _push(context, const AboutPage()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 退出登录
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout,
                    size: 18, color: Color(0xFFD48A8A)),
                label: const Text('退出登录',
                    style: TextStyle(color: Color(0xFFD48A8A))),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFF0E0E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(left: 44),
      child: Divider(height: 1, color: Color(0xFFF0EAF8)),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDot = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F2FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF6B6B8D)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3A3A5C))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            if (showDot)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                    color: Color(0xFFD48A8A), shape: BoxShape.circle),
              ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}