import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveLogin(String email, String token, String name, int phone) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'phone', value: phone.toString());
  }

  static Future<Map<String, String?>> getLoginData() async {
    String? email = await _storage.read(key: 'email');
    String? token = await _storage.read(key: 'token');
    String? name = await _storage.read(key: 'name');
    String? phone = await _storage.read(key: 'phone');

    return {
      'email': email,
      'token': token,
      'name': name,
      'phone': phone,
    };
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
