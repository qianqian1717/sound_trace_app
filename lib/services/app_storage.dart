import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';

class AppStorage {
  static const _kIntensity = 'intensity';
  static const _kDuration = 'duration';
  static const _kSensitivity = 'sensitivity';
  static const _kPreset = 'selectedPreset';
  static const _kNickname = 'nickname';
  static const _kGender = 'gender';
  static const _kRegion = 'region';
  static const _kPhone = 'phone';
  static const _kDeviceName = 'customDeviceName';
  static const _kLoggedIn = 'loggedIn';
  static const _kNotifyTypes = 'enabledNotifyTypes';

  static Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final s = AppState();

    s.intensity = sp.getDouble(_kIntensity) ?? s.intensity;
    s.duration = sp.getDouble(_kDuration) ?? s.duration;
    s.sensitivity = sp.getDouble(_kSensitivity) ?? s.sensitivity;
    s.selectedPreset = sp.getInt(_kPreset) ?? s.selectedPreset;

    s.nickname = sp.getString(_kNickname) ?? s.nickname;
    s.gender = sp.getString(_kGender) ?? s.gender;
    s.region = sp.getString(_kRegion) ?? s.region;
    s.phone = sp.getString(_kPhone) ?? s.phone;
    s.customDeviceName =
        sp.getString(_kDeviceName) ?? s.customDeviceName;
    s.loggedIn = sp.getBool(_kLoggedIn) ?? s.loggedIn;

    final notify = sp.getStringList(_kNotifyTypes);
    if (notify != null) {
      s.enabledNotifyTypes
        ..clear()
        ..addAll(notify);
    }
  }

  static Future<void> save() async {
    debugPrint('AppStorage.save() 被调用');
    final sp = await SharedPreferences.getInstance();
    final s = AppState();

    await sp.setDouble(_kIntensity, s.intensity);
    await sp.setDouble(_kDuration, s.duration);
    await sp.setDouble(_kSensitivity, s.sensitivity);
    await sp.setInt(_kPreset, s.selectedPreset);

    await sp.setString(_kNickname, s.nickname);
    await sp.setString(_kGender, s.gender);
    await sp.setString(_kRegion, s.region);
    await sp.setString(_kPhone, s.phone);
    await sp.setString(_kDeviceName, s.customDeviceName);
    await sp.setBool(_kLoggedIn, s.loggedIn);

    await sp.setStringList(
        _kNotifyTypes, s.enabledNotifyTypes.toList());
  }

  // 退出登录：清空登录状态，但保留其它数据
  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kLoggedIn, false);
    AppState().loggedIn = false;
  }
}