import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import 'profile_avatar_page.dart';
import 'profile_nickname_page.dart';
import 'profile_gender_page.dart';
import 'profile_region_page.dart';
import 'profile_phone_page.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final appState = AppState();

  void _go(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
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
              const Text('个人资料',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 20),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                    _row('头像', '', onTap: () => _go(ProfileAvatarPage())),
                    _divider(),
                    _row('昵称', appState.nickname,
                        onTap: () => _go(ProfileNicknamePage())),
                    _divider(),
                    _row('性别', appState.gender,
                        onTap: () => _go(ProfileGenderPage())),
                    _divider(),
                    _row('地区', appState.region,
                        onTap: () => _go(ProfileRegionPage())),
                    _divider(),
                    _row('手机号', appState.phone,
                        onTap: () => _go(ProfilePhonePage())),
                    _divider(),
                    _row('实验编号', appState.experimentId, readonly: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value,
      {bool readonly = false, VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: readonly ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3A5C))),
            const SizedBox(width: 6),
            if (!readonly)
              const Icon(Icons.chevron_right,
                  size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: Color(0xFFF0EAF8));
}