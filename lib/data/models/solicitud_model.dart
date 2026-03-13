enum EstadoSolicitud { enProceso, aprobado, rechazado, pendiente }

class SolicitudModel {
  final String id;
  final String titulo;
  final String subtitulo;
  final String tiempo;
  final EstadoSolicitud estado;

  const SolicitudModel({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.tiempo,
    required this.estado,
  });
}

enum TipoSolicitud {
  cambioCurso,
  cambioJornada,
  cursoDirigido,
  adicionCurso,
}

extension TipoSolicitudExt on TipoSolicitud {
  String get label {
    switch (this) {
      case TipoSolicitud.cambioCurso:   return 'Cambio de Curso';
      case TipoSolicitud.cambioJornada: return 'Cambio de Jornada';
      case TipoSolicitud.cursoDirigido: return 'Curso Dirigido';
      case TipoSolicitud.adicionCurso:  return 'Adición de Curso';
    }
  }

  String get description {
    switch (this) {
      case TipoSolicitud.cambioCurso:
        return 'Modifica tu inscripción a un grupo diferente.';
      case TipoSolicitud.cambioJornada:
        return 'Pasa de jornada diurna a nocturna o viceversa.';
      case TipoSolicitud.cursoDirigido:
        return 'Solicitud de materias para materias.';
      case TipoSolicitud.adicionCurso:
        return 'Adiciona una materia extra en tu semestre.';
    }
  }

  String get iconAsset {
    switch (this) {
      case TipoSolicitud.cambioCurso:   return 'swap_horiz';
      case TipoSolicitud.cambioJornada: return 'schedule';
      case TipoSolicitud.cursoDirigido: return 'menu_book';
      case TipoSolicitud.adicionCurso:  return 'add_circle_outline';
    }
  }

  String get apiValue {
    switch (this) {
      case TipoSolicitud.cambioCurso:   return 'cambio_curso';
      case TipoSolicitud.cambioJornada: return 'cambio_jornada';
      case TipoSolicitud.cursoDirigido: return 'curso_dirigido';
      case TipoSolicitud.adicionCurso:  return 'adicion_curso';
    }
  }
}