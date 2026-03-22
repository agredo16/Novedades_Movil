import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/grupo_model.dart';

class GrupoRepository {

  Future<List<GrupoModel>> getGrupos({
    String periodo = '2026-1',
  }) async {
    try {
      final response = await ApiService.get(
          '/grupos?periodo=$periodo');
      final data = response.data;

      if (data['ok'] == true && data['datos'] != null) {
        return (data['datos'] as List)
            .map((item) => GrupoModel.fromJson(item))
            .toList();
      } else {
        throw Exception(data['mensaje'] ?? 'Error al obtener grupos');
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