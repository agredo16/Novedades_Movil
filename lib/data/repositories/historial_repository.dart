import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/historial_model.dart';

class HistorialRepository {

  Future<List<HistorialSolicitudModel>> getMisSolicitudes() async {
    try {
      final response = await ApiService.get('/solicitudes/mias');
      final data = response.data;

      if (data['ok'] == true && data['datos'] != null) {
        return (data['datos'] as List)
            .map((item) => HistorialSolicitudModel.fromJson(item))
            .toList();
      } else {
        throw Exception(data['mensaje'] ?? 'Error al obtener solicitudes');
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