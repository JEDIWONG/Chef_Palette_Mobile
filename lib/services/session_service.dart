import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

Future<void> saveSessionToken(String token) async {
  await secureStorage.write(key: 'session_token', value: token);
}

Future<bool> isLoggedIn() async {
  final token = await secureStorage.read(key: 'session_token');
  return token != null;
}

Future<void> logout() async {
  await secureStorage.delete(key: 'session_token');
}

