class PerfilModel {
  final String codAlumno;
  final String nombreCompleto;
  final String emailInstitucional;
  final int semestre;
  final String nombrePrograma;
  final String jornada;
  final int creditosInscritos;
  final int creditosMaxPermitidos;
  final String estadoAcademico;
  final bool matriculaActiva;

  const PerfilModel({
    required this.codAlumno,
    required this.nombreCompleto,
    required this.emailInstitucional,
    required this.semestre,
    required this.nombrePrograma,
    required this.jornada,
    required this.creditosInscritos,
    required this.creditosMaxPermitidos,
    required this.estadoAcademico,
    required this.matriculaActiva,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    return PerfilModel(
      codAlumno:             json['cod_alumno']              ?? '',
      nombreCompleto:        json['nombre_completo']         ?? '',
      emailInstitucional:    json['email_institucional']     ?? '',
      semestre:              json['semestre']                ?? 0,
      nombrePrograma:        json['nombre_programa']         ?? '',
      jornada:               json['jornada']                 ?? '',
      creditosInscritos:     json['creditos_inscritos']      ?? 0,
      creditosMaxPermitidos: json['creditos_max_permitidos'] ?? 20,
      estadoAcademico:       json['estado_academico']        ?? '',
      matriculaActiva:       json['matricula_activa']        ?? false,
    );
  }

  String get jornadaLabel {
    switch (jornada) {
      case 'manana': return 'Mañana';
      case 'tarde':  return 'Tarde';
      case 'noche':  return 'Noche';
      default:       return jornada.isNotEmpty ? jornada : 'No definida';
    }
  }

  String get iniciales {
    final partes = nombreCompleto.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    if (partes.isNotEmpty && partes[0].isNotEmpty) {
      return partes[0][0].toUpperCase();
    }
    return 'E';
  }
}