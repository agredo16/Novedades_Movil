import 'package:dio/dio.dart';
import '../datasources/remote/api_service.dart';
import '../models/solicitud_request_model.dart';

class SolicitudRepository {

  Future<SolicitudResponseModel> crearSolicitud(
      SolicitudRequestModel request) async {
    try {
      final response = await ApiService.post(
        '/solicitudes',
        request.toJson(),
      );

      final data = response.data;

      if (data['ok'] == true && data['datos'] != null) {
        return SolicitudResponseModel.fromJson(data['datos']);
      } else {
        throw Exception(
          data['mensaje'] ?? 'Solicitud rechazada por validaciones'
        );
      }

    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response?.data;
        throw Exception(data['mensaje'] ?? 'Error del servidor');
      }
      throw Exception('No se pudo conectar al servidor');

    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}