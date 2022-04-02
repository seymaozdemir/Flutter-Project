import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyUsername = 'username';
  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);
  static Future getUsername() async => await _storage.read(key: _keyUsername);
  static const _keySifre = 'sifre';
  static Future setSifre(String sifre) async =>
      await _storage.write(key: _keySifre, value: sifre);
  static Future getSifre() async => await _storage.read(key: _keySifre);
  static const _keyAuthToken = 'authToken';
  static Future setAuthToken(String authToken) async =>
      await _storage.write(key: _keyAuthToken, value: authToken);
  static Future getAuthToken() async => await _storage.read(key: _keyAuthToken);
}
