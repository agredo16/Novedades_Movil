import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/perfil_model.dart';

class PerfilRepository {

  Future<PerfilModel> getPerfil() async {
    try {
      final response = await ApiService.get('/estudiantes/perfil');
      final data = response.data;

      if (data['ok'] == true && data['datos'] != null) {
        return PerfilModel.fromJson(data['datos']);
      } else {
        throw Exception(data['mensaje'] ?? 'Error al obtener perfil');
      }

    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception(e.response?.data['mensaje'] ?? 'Error del servidor');
      }
      throw Exception('No se pudo conectar al servidor');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}