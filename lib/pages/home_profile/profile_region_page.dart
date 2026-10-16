import 'package:flutter/material.dart';
import '../../models/app_state.dart';

class ProfileRegionPage extends StatelessWidget {
  const ProfileRegionPage({super.key});

  // P0 先用假数据，以后接省市区 JSON 或定位
  final List<String> _regions = const [
    '北京市',
    '上海市',
    '广东省 深圳市',
    '广东省 广州市',
    '浙江省 杭州市',
    '江苏省 南京市',
    '四川省 成都市',
    '湖北省 武汉市',
    '其他',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
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
              const Text('地区',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A5C))),
              const SizedBox(height: 8),
              const Text('P0 阶段先手动选择，后续可接入自动定位',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.separated(
                    itemCount: _regions.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 1, color: Color(0xFFF0EAF8)),
                    itemBuilder: (context, i) {
                      final r = _regions[i];
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          appState.region = r;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              Text(r,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF3A3A5C))),
                              const Spacer(),
                              if (appState.region == r)
                                const Icon(Icons.check,
                                    size: 18, color: Color(0xFF8A8AA8)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}