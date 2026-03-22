class HistorialSolicitudModel {
  final String id;
  final String codigoSolicitud;
  final String tipoSolicitud;
  final String estado;
  final String justificacion;
  final String periodoAcademico;
  final DateTime createdAt;
  final List<ValidacionHistorial> validaciones;

  const HistorialSolicitudModel({
    required this.id,
    required this.codigoSolicitud,
    required this.tipoSolicitud,
    required this.estado,
    required this.justificacion,
    required this.periodoAcademico,
    required this.createdAt,
    required this.validaciones,
  });

  factory HistorialSolicitudModel.fromJson(Map<String, dynamic> json) {
    List<ValidacionHistorial> validaciones = [];
    if (json['validacion_json'] != null &&
        json['validacion_json']['validaciones'] != null) {
      validaciones = (json['validacion_json']['validaciones'] as List)
          .map((v) => ValidacionHistorial.fromJson(v))
          .toList();
    }

    return HistorialSolicitudModel(
      id:               json['id'].toString(),
      codigoSolicitud:  json['codigo_solicitud'],
      tipoSolicitud:    json['tipo_solicitud'],
      estado:           json['estado'],
      justificacion:    json['justificacion'],
      periodoAcademico: json['periodo_academico'],
      createdAt:        DateTime.parse(json['created_at']),
      validaciones:     validaciones,
    );
  }

  // Helper para mostrar el tipo legible
  String get tipoLabel {
    switch (tipoSolicitud) {
      case 'ADICION':        return 'Adición de Curso';
      case 'CAMBIO_JORNADA': return 'Cambio de Jornada';
      case 'CAMBIO_CURSO':   return 'Cambio de Curso';
      case 'CURSO_DIRIGIDO': return 'Curso Dirigido';
      default:               return tipoSolicitud;
    }
  }

  // Helper para el estado como enum visual
  EstadoVisual get estadoVisual {
    switch (estado) {
      case 'APROBADO':  return EstadoVisual.aprobado;
      case 'RECHAZADO': return EstadoVisual.rechazado;
      case 'PENDIENTE': return EstadoVisual.pendiente;
      default:          return EstadoVisual.enProceso;
    }
  }
}

class ValidacionHistorial {
  final String nombre;
  final String detalle;
  final bool resultado;

  const ValidacionHistorial({
    required this.nombre,
    required this.detalle,
    required this.resultado,
  });

  factory ValidacionHistorial.fromJson(Map<String, dynamic> json) {
    return ValidacionHistorial(
      nombre:    json['nombre'],
      detalle:   json['detalle'],
      resultado: json['resultado'],
    );
  }
}

enum EstadoVisual { aprobado, rechazado, pendiente, enProceso }