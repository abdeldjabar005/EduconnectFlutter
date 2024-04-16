import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenProvider {
  final FlutterSecureStorage secureStorage;

  TokenProvider({required this.secureStorage});

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> setToken(String token) async {
    await secureStorage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'token');
  }
}


