class GrupoModel {
  final int id;
  final String codigoGrupo;
  final String nombreCurso;
  final String codCurso;
  final String jornada;
  final String diaSemana;
  final String horaInicio;
  final String horaFin;
  final String docente;
  final String aula;
  final int cupoMaximo;
  final int cuposOcupados;
  final int cuposDisponibles;
  final String periodo;

  const GrupoModel({
    required this.id,
    required this.codigoGrupo,
    required this.nombreCurso,
    required this.codCurso,
    required this.jornada,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.docente,
    required this.aula,
    required this.cupoMaximo,
    required this.cuposOcupados,
    required this.cuposDisponibles,
    required this.periodo,
  });

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(
      id:               json['id'],
      codigoGrupo:      json['codigo_grupo']      ?? '',
      nombreCurso:      json['nombre_curso']       ?? '',
      codCurso:         json['cod_curso']          ?? '',
      jornada:          json['jornada']            ?? '',
      diaSemana:        json['dia_semana']         ?? '',
      horaInicio:       json['hora_inicio']        ?? '',
      horaFin:          json['hora_fin']           ?? '',
      docente:          json['docente']            ?? '',
      aula:             json['aula']               ?? '',
      cupoMaximo:       json['cupo_maximo']        ?? 0,
      cuposOcupados:    json['cupos_ocupados']     ?? 0,
      cuposDisponibles: json['cupos_disponibles']  ?? 0,
      periodo:          json['periodo']            ?? '',
    );
  }

  String get dropdownLabel =>
      '$nombreCurso · $codigoGrupo · ${jornadaLabel} · $diaSemana ${_formatHora(horaInicio)}';

  String get jornadaLabel {
    switch (jornada) {
      case 'manana': return 'Mañana';
      case 'tarde':  return 'Tarde';
      case 'noche':  return 'Noche';
      default:       return jornada;
    }
  }

  String _formatHora(String hora) {
    try {
      final partes = hora.split(':');
      int h = int.parse(partes[0]);
      final m = partes[1];
      final ampm = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;
      return '$h:$m $ampm';
    } catch (_) {
      return hora;
    }
  }

  bool get tieneCupos => cuposDisponibles > 0;
}