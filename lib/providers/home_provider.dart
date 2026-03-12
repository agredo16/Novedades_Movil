import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/solicitud_model.dart';

// Stats
final statsProvider = Provider<Map<String, int>>((ref) => {
  'enProceso': 3,
  'aprobadas': 12,
  'rechazadas': 1,
});

// Solicitudes recientes
final solicitudesRecientesProvider = Provider<List<SolicitudModel>>((ref) => [
  const SolicitudModel(
    id: '1',
    titulo: 'Cambio de Curso',
    subtitulo: 'Cálculo Diferencial - Grupo B',
    tiempo: 'Hace 2 horas',
    estado: EstadoSolicitud.enProceso,
  ),
  const SolicitudModel(
    id: '2',
    titulo: 'Adición de Asignatura',
    subtitulo: 'Ética y Ciudadanía',
    tiempo: 'Ayer',
    estado: EstadoSolicitud.aprobado,
  ),
  const SolicitudModel(
    id: '3',
    titulo: 'Curso Dirigido',
    subtitulo: 'Física Mecánica',
    tiempo: '15 Oct',
    estado: EstadoSolicitud.rechazado,
  ),
]);