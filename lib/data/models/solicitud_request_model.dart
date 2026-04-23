class SolicitudRequestModel {
  final String tipoSolicitud;
  final String justificacion;
  final String periodoAcademico;
  final int? grupoNuevoId;
  final int? grupoActualId;
  final String? jornadaActual;
  final String? jornadaNueva;
  final String? adjuntoBase64;
  final String? nombreAdjunto;

  const SolicitudRequestModel({
    required this.tipoSolicitud,
    required this.justificacion,
    required this.periodoAcademico,
    this.grupoNuevoId,
     this.grupoActualId,
    this.jornadaActual,
    this.jornadaNueva,
    this.adjuntoBase64,
    this.nombreAdjunto,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'tipo_solicitud':    tipoSolicitud,
      'justificacion':     justificacion,
      'periodo_academico': periodoAcademico,
    };
    if (grupoNuevoId != null)  json['grupo_nuevo_id']  = grupoNuevoId;
    if (grupoActualId != null) json['grupo_actual_id']  = grupoActualId;
    if (jornadaActual != null) json['jornada_actual']   = jornadaActual;
    if (jornadaNueva != null)  json['jornada_nueva']    = jornadaNueva;
    if (adjuntoBase64 != null) json['adjunto_base64']   = adjuntoBase64;
    if (nombreAdjunto != null) json['nombre_adjunto']   = nombreAdjunto;
    return json;
  }
}

class ValidacionItem {
  final String nombre;
  final String detalle;
  final bool resultado;

  const ValidacionItem({
    required this.nombre,
    required this.detalle,
    required this.resultado,
  });

  factory ValidacionItem.fromJson(Map<String, dynamic> json) {
    return ValidacionItem(
      nombre:    json['nombre'],
      detalle:   json['detalle'],
      resultado: json['resultado'],
    );
  }
}

class SolicitudResponseModel {
  final String id;
  final String codigoSolicitud;
  final String estado;
  final String tipoSolicitud;
  final DateTime createdAt;
  final List<ValidacionItem> validaciones;

  const SolicitudResponseModel({
    required this.id,
    required this.codigoSolicitud,
    required this.estado,
    required this.tipoSolicitud,
    required this.createdAt,
    required this.validaciones,
  });

  factory SolicitudResponseModel.fromJson(Map<String, dynamic> json) {
    List<ValidacionItem> validaciones = [];
    if (json['validacion_json'] != null &&
        json['validacion_json']['validaciones'] != null) {
      validaciones = (json['validacion_json']['validaciones'] as List)
          .map((v) => ValidacionItem.fromJson(v))
          .toList();
    }

    return SolicitudResponseModel(
      id:              json['id'].toString(),
      codigoSolicitud: json['codigo_solicitud'],
      estado:          json['estado'],
      tipoSolicitud:   json['tipo_solicitud'],
      createdAt:       DateTime.parse(json['created_at']),
      validaciones:    validaciones,
    );
  }
}