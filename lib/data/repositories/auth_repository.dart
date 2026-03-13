import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/remote/api_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  static const _storage = FlutterSecureStorage();

  Future<UserModel> login({
    required String codigoEstudiantil,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'codigo_estudiantil': codigoEstudiantil,
        'password': password,
      });

      final data = response.data;

      if (data['ok'] == true && data['datos'] != null) {
        final user = UserModel.fromJson(data['datos']);
        await _storage.write(key: 'auth_token', value: user.token);
        await _storage.write(key: 'user_nombre', value: user.nombreCompleto);
        await _storage.write(key: 'user_codigo', value: user.codigoEstudiantil);
        return user;
      } else {
        throw Exception(data['mensaje'] ?? 'Credenciales incorrectas');
      }

    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response?.data;
        throw Exception(data['mensaje'] ?? 'Credenciales incorrectas');
      }
      throw Exception('No se pudo conectar al servidor');

    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }
}